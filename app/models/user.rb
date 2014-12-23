class User < ActiveRecord::Base

  include Searchable, BalancedPayment, TwoFactor, Authentication, Measurement, Sortable

  #
  # Plugins
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  sortable :full_name, :email, :unread_message_counter, :mobile_nr
  
  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  attr_accessor :balanced_token, :wizard_step
  
  store :additionals, accessors: [:fb_first_name, :fb_last_name, :fb_gender, :fb_locale, :fb_timezone, :fb_link]
  
  AS_SEARCHABLE_JSON = [:id, :email, :full_name, :mobile_nr, :unread_message_counter, :currency]
  AS_SEARCHABLE_METHODS = []
  AS_SEARCHABLE_INCLUDES = {}
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :full_name, presence: true

  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  has_many :profiles, dependent: :destroy
  has_many :bookings, class_name: 'Deal', foreign_key: :customer_id, dependent: :destroy

  has_many :artist_deals, class_name: 'Deal', foreign_key: :artist_id, dependent: :destroy
  
  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id, dependent: :delete_all
  has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id, dependent: :delete_all

  has_many :sent_conversations, class_name: 'Conversation', foreign_key: :sender_id, dependent: :delete_all
  has_many :received_conversations, class_name: 'Conversation', foreign_key: :receiver_id, dependent: :delete_all
  
  has_many :reviews, foreign_key: :author_id, dependent: :delete_all
  
  has_many :events, dependent: :destroy
  
  mount_uploader :avatar, AvatarUploader
  
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_save :generate_secrete_key
  
  before_save :set_default_currency, :add_credit_card
  
  after_save :update_profile_wizard_step, on: :update
  
  after_destroy :delete_balanced_customer

  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  scope :latest, -> { order("ID DESC") }

  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def has_avatar?
    self[:avatar].present?
  end
  
  def mobile_number
    return nil if mobile_nr.blank?
    return mobile_nr if mobile_nr.starts_with?("+") || mobile_nr.starts_with?("0")
    "+#{mobile_nr_country_code}#{mobile_nr}"
  end
  
  def deals
    Deal.by_user(self.id)
  end

  def conversations
    Conversation.by_user(self.id).ordered_by_last_message
  end
  
  def archived_conversations
    conversations.archived_by(id)
  end

  def unarchived_conversations
    conversations.unarchived_by(id)
  end
  
  def messages
    Message.by_user(self.id)
  end
  
  def profile
    @profile ||= profiles.first
  end
  
  def artist?
    @artist ||= profile.present?
  end
  
  def pending_deal_with_profile(profile)
    bookings.pending.by_profile(profile.id).first
  end
  
  def profile_name
    profile.try(:name) || name
  end
  
  def name
    full_name
  end
  
  def paymentable?
    balanced_customer_id.present? && balanced_card_id.present?
  end
  
  def make_paymentable_by_token(token)
    self.balanced_token = token
    add_credit_card
    return save
  end
  
  def send_sms(message)
    SmsWorker.perform_async(id, message) if mobile_nr_confirmed?
  end
  
  def subscribe_to_newsletter
    MailchimpWorker.perform_async(:subscribe_user, id)
  end
  
  def notify_admin
    AdminMailer.delay.lead_notification(self)
  end
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def generate_secrete_key
    self.otp_secret_key ||= ROTP::Base32.random_base32
  end
  
  def set_default_currency
    self.currency ||= Rails.configuration.default_currency
  end

  def after_confirmation
    subscribe_to_newsletter
    notify_admin
  end
  
  def add_credit_card    
    if balanced_token.present? 
      if balanced_customer_id.blank?
        balanced_customer = create_balanced_customer
        return balanced_customer && assign_card_to_balanced_customer(balanced_customer, balanced_token)
      elsif balanced_card_id.blank?
        return create_balanced_card
      end
    end
  end
  
  def delete_balanced_customer
    BalancedWorker.perform_async(:delete_card, balanced_card_id)
    BalancedWorker.perform_async(:delete_customer, balanced_customer_id)
  end
  
  def update_profile_wizard_step
    if profile.present?
      profile.assign_description_step!
    end
  end
  
end
