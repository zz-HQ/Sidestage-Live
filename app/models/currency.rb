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
  scope :pounds, -> { where(name: "GBP") }
  scope :dollars, -> { where(name: "USD") }
  
  
  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  
  def self.pound
    pounds.first
  end

  def self.dollar
    dollars.first
  end
  
end
