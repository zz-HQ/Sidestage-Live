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
  
  # TODO: save token in database
  attr_accessor :stripe_token
  store :social_media, accessors: [ :facebook, :twitter, :soundcloud, :blog ]

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

  has_many :outgoing_messages, class_name: 'Message', foreign_key: :sender_id
  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id, dependent: :nullify
  has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id, dependent: :nullify
  
  has_many :booking_requests, class_name: 'Deal', foreign_key: :customer_id, autosave: false
  has_many :offers, -> { offers }, class_name: 'Deal', foreign_key: :artist_id  

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
    #if changes.include?(:stripe_token)
      self.stripe_customer_id ||= create_stripe_customer(stripe_token, email).try(:id) if stripe_token.present?
    #end
  end
  
end
