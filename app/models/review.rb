class Review < ActiveRecord::Base

  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :profile_id, :author_id, :body, presence: true
  
  

  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  belongs_to :profile
  belongs_to :artist
  belongs_to :author
  

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_create :assign_artist  
  

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def assign_artist
    self.artist_id ||= profile.user_id if profile_id.present?
  end
  
end
