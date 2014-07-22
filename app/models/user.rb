class User < ActiveRecord::Base

  include Payment
  include TwoFactor
  include Authentication

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
  has_many :messages, class_name: 'Message', foreign_key: :sender_id
  has_many :bookings, class_name: 'Deal', foreign_key: :customer_id
  
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

  after_create :add_to_newsletter, :notify_admin

  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

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
    profile.present?
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

  def add_to_newsletter
    if self.newsletter_subscribed?
      Rails.logger.debug { "newsletter set #{self.newsletter_subscribed}" }
      mailchimp_api = Gibbon::API.new
      res = mailchimp_api.lists.batch_subscribe(id: Rails.application.secrets.mailchimp_newsletter_id, :double_optin => false, :batch => [{:email => {:email => self.email}, :merge_vars => {:FNAME => self.first_name, :LNAME => self.last_name}}])
    else
      logger.debug { "no newsletter set" }
    end
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
