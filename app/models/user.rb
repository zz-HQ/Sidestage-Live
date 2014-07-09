class User < ActiveRecord::Base

  include Payment

  #
  # Plugins
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable
  devise :omniauthable, :omniauth_providers => [:facebook]

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  attr_accessor :stripe_token
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :first_name, :last_name, presence: true
  

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
  
  before_save :set_default_currency, :add_credit_card
  after_create :add_to_newsletter, :notify_admin

  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.remote_avatar_url = auth.info.image.gsub('http://','https://') # assuming the user model has an image
      user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

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
  
  def messages
    Message.by_user(self.id)
  end
  
  def profile
    @profile ||= profiles.first
  end
  
  def profile_name
    profile.try(:name) || name
  end
  
  def name
    [first_name, last_name].join(" ")
  end
  
  def paymentable?
    stripe_customer_id.present? && stripe_card_id.present?
  end
  
  def make_paymentable_by_token(token)
    self.stripe_token = token
    add_credit_card
    return save
  end
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
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
    AdminMailer.lead_notification(self).deliver
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
