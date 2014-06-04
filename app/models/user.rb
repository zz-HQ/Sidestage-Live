class User < ActiveRecord::Base

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
  
  store :social_media, accessors: [ :facebook, :twitter, :soundcloud, :blog ]

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
  
  has_many :booking_requests, class_name: 'Deal', foreign_key: :customer_id
  has_many :offers, -> { offers }, class_name: 'Deal', foreign_key: :artist_id  

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_save :set_default_currency
  
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
  
end
