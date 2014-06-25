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

  mount_uploader :avatar, AvatarUploader
  
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_save :set_default_currency, :set_payment_info
  
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
  
  def save_stripe_customer_id!(customer_id)
    update_attribute :stripe_customer_id, customer_id
  end
  
  def paymentable?
    stripe_customer_id.present?
  end
  
  def make_paymentable_by_token(token)
    self.stripe_token = token
    set_payment_info
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
  
  def set_payment_info    
    if changes.include?(:stripe_token)
      self.stripe_customer_id ||= create_stripe_customer(self).try(:id) if stripe_token.present?
    end
  end
  
end
