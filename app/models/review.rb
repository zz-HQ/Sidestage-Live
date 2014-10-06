class Review < ActiveRecord::Base

  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :profile_id, :author_id, :body, presence: true
  validates :rate, numericality: true, allow_blank: true

  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  belongs_to :profile
  belongs_to :artist
  belongs_to :author, class_name: User
  

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_create :assign_artist  
  
  after_create :notify_admin

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
  
  
  def notify_admin
    AdminMailer.delay.review_notification(self)
  end
  
  
end
