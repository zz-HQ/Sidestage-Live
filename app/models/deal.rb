class Deal < ActiveRecord::Base

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :artist_id, :profile_id, :customer_id, :price, :start_at, presence: true
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
    update_attribute :customer_accepted_at, Time.now
  end

  def confirm!
    update_attribute :artist_accepted_at, Time.now
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
    message.body =  note || "Deal..."
    message.save
    message
  end
  

end
