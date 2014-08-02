class User < ActiveRecord::Base

  include Payment, TwoFactor, Authentication, Measurement

  #
  # Plugins
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  attr_accessor :stripe_token, :wizard_step
  
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

  after_create :notify_admin

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
  
  def profile_name
    profile.try(:name) || name
  end
  
  def name
    full_name
  end
  
  def paymentable?
    stripe_customer_id.present? && stripe_card_id.present?
  end
  
  def make_paymentable_by_token(token)
    self.stripe_token = token
    add_credit_card
    return save
  end
  
  def send_sms(message)
    SmsWorker.perform_async(id, message) if mobile_nr_confirmed?
  end
  
  def subscribe_to_newsletter
    MailchimpWorker.perform_async(id)
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
  end
  
  def notify_admin
    AdminMailer.delay.lead_notification(self)
  end
  
  def add_credit_card    
    if stripe_token.present? 
      if stripe_customer_id.blank?
        return create_stripe_customer
      elsif stripe_card_id.blank?
        return create_stripe_card
      end
    end
  end
  
end
