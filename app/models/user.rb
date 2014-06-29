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
