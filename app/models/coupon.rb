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
  validates :code, uniqueness: { case_sensitive: false }, allow_blank: true

  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  sortable :code, :amount, :currency, :expires_at

  scope :latest, -> { order("coupons.id DESC") }
  scope :active, -> { where("active IS ? OR active = ?", nil, true) }
  scope :valid, -> { where("expires_at IS ? OR expires_at > ?", nil, Time.now) }
  
  
end
