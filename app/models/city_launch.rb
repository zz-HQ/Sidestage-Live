class CityLaunch < ActiveRecord::Base

  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  validates :email, :city, presence: true
  validates :email, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }
  
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  after_create :notify_admin
  
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def notify_admin
    AdminMailer.delay.more_cities(self)
  end
  
  
end
