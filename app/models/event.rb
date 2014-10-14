class Event < ActiveRecord::Base

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  store :additionals, accessors: []

  #
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  validates :user_id, presence: true
  
end
