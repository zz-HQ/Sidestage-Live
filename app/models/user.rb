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
  
  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id, dependent: :nullify
  has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id, dependent: :nullify
  
  has_many :booking_offers, foreign_key: :artist_id
  has_many :booking_requests, foreign_key: :requestor_id  
  
  has_many :received_booking_offers, foreign_key: :requestor_id, class_name: 'BookingOffer'
  has_many :received_booking_requests, foreign_key: :artist_id, class_name: 'BookingRequest'
    
  # has_many :received_booking_requests, -> { requests }, class_name: 'Booking', foreign_key: :artist_id
  # has_many :received_booking_offers, -> { offers }, class_name: 'Booking', foreign_key: :requestor_id
  # has_many :sent_booking_requests, -> { requests }, class_name: 'Booking', foreign_key: :requestor_id
  # has_many :sent_booking_offers, -> { offers }, class_name: 'Booking', foreign_key: :artist_id
    
  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def messages
    Message.by_user(self.id)
  end
  
  def profile
    @profile ||= profiles.first
  end
  
  def name
    [first_name, last_name].join(" ")
  end
  
end
