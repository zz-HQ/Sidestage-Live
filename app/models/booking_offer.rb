class BookingOffer < ActiveRecord::Base

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  validates :requestor_id, :artist_id, :price, :start_at, presence: true
  validates :price, numericality: { only_integer: true }


  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  belongs_to :requestor, foreign_key: :requestor_id, class_name: 'User'
  belongs_to :artist, foreign_key: :artist_id, class_name: 'User'  

  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  default_scope -> { order("id DESC") }

end
