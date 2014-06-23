class Deal < ActiveRecord::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  include Deal::StateMachine
  include Conversationable
  include Payment
  
  has_paper_trail only: [ :state ], on: [:update, :destroy], class_name: "Versions::#{self.name}"
  
  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  attr_accessor :current_user, :stripe_token

  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :artist_id, :profile_id, :customer_id, :price, :start_at, :currency, :conversation_id, presence: true
  validates :price, numericality: true, allow_blank: true 
  
  validate :customer_must_be_chargeable, on: :create

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_validation :assign_artist, :assign_customer, :set_price, :set_currency, :attach_to_conversation, :make_customer_paymentable, on: :create
  
  before_save :set_state_transition_at

  after_save :create_system_message
  
  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  belongs_to :profile
  belongs_to :artist, foreign_key: :artist_id, class_name: 'User'
  belongs_to :customer, foreign_key: :customer_id, class_name: 'User'

  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  scope :by_user, ->(user_id) { where('artist_id = :user_id OR customer_id = :user_id', user_id: user_id) }
  scope :between, ->(customer_id, artist_id) { where(artist_id: [artist_id, customer_id], customer_id: [artist_id, customer_id]) }

  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def is_customer?(user)
    customer_id == user.id
  end

  def is_artist?(user)
    artist_id == user.id
  end
  
  
  def price_in_cents
    price * 100
  end

  def partner_id
    current_user.id == artist_id ? customer_id : artist_id
  end  
    
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  #
  # Initialization
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  def assign_artist
    self.artist_id ||= profile.try(:user_id)
  end
  
  def assign_customer
    self.customer_id ||= current_user.id
  end
  
  def set_price
    self.price ||= profile.try(:price_with_surcharge)
  end

  def set_currency
    self.currency ||= profile.try(:currency)
  end
  
  def set_state_transition_at
    self.state_transition_at = Time.now if changes.include?('state')
  end

  
  #
  # Custom Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def customer_must_be_chargeable
    errors.add :customer_id, :not_chargeable unless customer.paymentable?
    customer.paymentable?
  end
  
  #
  # Background
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create_system_message
    if changes.include?('price') || changes.include?('state')
      message = Message.new current_user: current_user, receiver_id: partner_id, conversation_id: conversation_id, system_message: true
      message.body = { 
        source: self.class.name, 
        source_id: self.id, 
        state: state, 
        current_user_id: current_user.id, 
        customer_id: customer_id, 
        artist_id: artist_id,
        price: price,
        event_date: start_at }.to_json
      message.save
    end
  end
  
  def make_customer_paymentable
    if stripe_token.present?
      customer.make_paymentable_by_token(stripe_token)
      errors.add :stripe_token, customer.errors.full_messages.first if customer.errors.present?
    end
  end
  

  

end
