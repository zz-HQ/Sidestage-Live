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
  
  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  def still_valid?
    expires_at.nil? || expires_at > Time.now
  end
  
  def surcharged_profile_price(profile)
    coupon_price = CurrencyConverterService.convert(amount, currency, profile.currency)
    new_price = profile.price.with_surcharge - coupon_price
    new_price < 0 ? 0 : new_price.round
  end

  def deal_price(deal)
    coupon_price = CurrencyConverterService.convert(amount, currency, deal.currency)
    new_price = deal.customer_price - coupon_price
    new_price < 0 ? 0 : new_price.round
  end
  
  def event_price
    coupon_price = CurrencyConverterService.convert(amount, currency, Event.black_currency)
    new_price = Event::BLACK_PRICE - coupon_price
    new_price < 0 ? 0 : new_price.round
  end

  
end
