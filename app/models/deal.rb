class Deal < ActiveRecord::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  include Deal::StateMachine
  
  has_paper_trail only: [ :state ], on: [:update, :destroy], class_name: "Versions::#{self.name}"
  
  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  attr_accessor :current_user

  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :artist_id, :profile_id, :customer_id, :conversation_id, :price, :start_at, :currency, presence: true
  validates :price, numericality: true, allow_blank: true 
  validate :customer_must_be_chargeable, on: :create

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
  belongs_to :message
  belongs_to :conversation

  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  scope :by_user, ->(user_id) { where('artist_id = :user_id OR customer_id = :user_id', user_id: user_id) }
  
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_validation :assign_artist, :set_price, :set_currency, :attach_to_conversation, on: :create
  
  before_save :set_state_transition_at
  
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
    
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def assign_artist
    self.artist_id ||= profile.try(:user_id)
  end
  
  def set_price
    self.price ||= profile.try(:price)
  end

  def set_currency
    self.currency ||= profile.try(:currency)
  end
  
  def set_state_transition_at
    self.state_transition_at = Time.now if changes.include?('state')
  end
  
  def attach_to_conversation
    return if artist.nil?
    self.conversation ||= self.artist.conversations.by_user(self.customer_id).first || create_conversation
  end
  
  def create_conversation
    conversation = Conversation.new
    conversation.sender_id = current_user.id
    conversation.receiver_id = current_user.id == artist_id ? customer_id : artist_id
    conversation.body = note
    conversation.last_message_at = Time.now    
    conversation.save
    conversation
  end
  
  def price_in_cents
    price * 100
  end
  
  def customer_must_be_chargeable
    errors.add :customer_id, :not_chargeable unless customer.paymentable?
  end
  
  def charge_customer
    return false if stripe_charge_id.present?
    
    if customer.stripe_customer_id.blank?
      errors.add :payment, "No payment info available."
      return false
    end
    
    begin
      charge = Stripe::Charge.create(
        :amount => price_in_cents,
        :currency => currency,
        :customer => customer.stripe_customer_id,
        :description => "Deal #{customer.name}"
      )
      self.charged_price = price_in_cents
      self.stripe_charge_id = charge.id
      return save(validate: false)
    rescue Stripe::CardError => e
      # TODO: Stripe Charge CardError
      User.where(id: customer.id).update_all(stripe_log: e.json_body.inspect) 
      Rails.logger.info "##########################"
      Rails.logger.info e.inspect
      Rails.logger.info "##########################"
    end
    
  end
  

end
