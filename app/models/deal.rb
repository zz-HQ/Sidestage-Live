class Deal < ActiveRecord::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  include Deal::StateMachine
  
  has_paper_trail :meta => {},
                  :only => [ :state ],
                  :class_name => "Versions::#{self.name}"
  
  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :artist_id, :profile_id, :customer_id, :conversation_id, :price, :start_at, :currency, presence: true
  validates :price, numericality: true, allow_blank: true 
  validate :artist_must_be_valid_user, :customer_must_be_valid_user

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
  
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_validation :assign_artist, :set_price, :set_currency, :attach_to_conversation, on: :create
  
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
  
  def artist_must_be_valid_user
    errors.add :artist_id, :blank unless artist.present?
  end
  
  def customer_must_be_valid_user
    errors.add :customer_id, :blank unless customer.present?
  end
  
  def assign_artist
    self.artist_id ||= profile.try(:user_id)
  end
  
  def set_price
    self.price ||= profile.try(:price)
  end

  def set_currency
    self.currency ||= profile.try(:currency)
  end
  
  def attach_to_conversation
    return if artist.nil?
    self.conversation ||= self.artist.conversations.where('receiver_id = :id OR sender_id = :id', id: self.customer_id).first || create_conversation
  end
  
  def create_conversation
    conversation = Conversation.new
    conversation.sender_id = self.customer_id
    conversation.receiver_id = self.artist_id
    conversation.body = note
    conversation.last_message_at = Time.now    
    conversation.save
    conversation
  end
  
  def price_in_cents
    price * 100
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
