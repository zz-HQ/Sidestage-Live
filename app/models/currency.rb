class Currency < ActiveRecord::Base

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :name, :symbol, presence: true


  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  default_scope -> { order("name ASC") }
  
  
end
