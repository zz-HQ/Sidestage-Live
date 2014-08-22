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
  
  
  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  
  def self.pound
    where(name: "GBP").first
  end
  
end
