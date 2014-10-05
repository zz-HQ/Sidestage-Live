class Coupon < ActiveRecord::Base
  
  include Sortable
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :code, :amount, :currency, presence: true
  validates :amount, numericality: true, allow_blank: true


  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  sortable :code, :amount, :currency, :expires_at

  scope :latest, -> { order("coupons.id DESC") }
  
end
