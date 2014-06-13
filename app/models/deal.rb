class Deal < ActiveRecord::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  include Priceable
  
  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  validates :artist_id, :profile_id, :customer_id, :conversation_id, :price, :start_at, :currency, presence: true
  validates :price, numericality: true, allow_blank: true 
  validate :validate_artist, :validate_customer

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
  
  scope :offers, -> { where(offer: true) }
  scope :by_user, ->(user_id) { where("artist_id = :user_id OR customer_id = :user_id" , user_id: user_id) }

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_validation :assign_artist, :set_price, :attach_message, :attach_conversation, on: :create
  
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
  
  def accepted?
    customer_accepted_at.present?
  end

  def confirmed?
    artist_accepted_at.present?
  end
  
  def accept!
    charge_customer
    self.customer_accepted_at = Time.now
    return save
  end

  def confirm!
    charge_customer
    self.artist_accepted_at = Time.now
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
  
  def validate_artist
    errors.add :artist_id unless artist.present?
  end
  
  def validate_customer
    errors.add :customer_id unless customer.present?
  end
  
  def assign_artist
    self.artist_id ||= profile.user_id
  end
  
  def set_price
    self.price ||= profile.price unless offer?
  end
  
  def attach_conversation
    self.conversation_id ||= message.conversation_id
  end

  def attach_message
    self.message ||= create_message
  end
  
  def create_message
    message = Message.new
    message.sender_id = offer? ? self.artist_id : self.customer_id
    message.receiver_id = offer? ? self.customer_id : self.artist_id
    message.body =  "You can accept or deny this request or message the user. This request will automatically be cancelled in 48 hours if you don't reply."
    message.save
    message
  end
  
  def charge_customer
    return if stripe_charge_id.present?
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
      Rails.logger.info e.inspect
    rescue Error => e
      Rails.logger.info e.inspect
    end
    
  end
  

end
