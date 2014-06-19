class CurrencyRate < ActiveRecord::Base

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :rate_from, :rate_to, :rate, presence: true  
  validates :rate, numericality: { greater_than: 0 }

  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  belongs_to :currency, autosave: false

  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  scope :from_to, ->(from, to) { where(rate_from: from, rate_to: to) }

  
end
