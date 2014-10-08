module Deal::DealCoupon
  extend ActiveSupport::Concern
  
  included do
    
    after_save :reset_coupon_upon_offer
    
  end
  
  
  def coupon_applied?
    coupon_price.present?
  end
  
  def apply_coupon!(coupon)
    self.coupon_code = coupon.code
    self.coupon_price = coupon.deal_price(self)
    self.coupon_id = coupon.id
    save! validate: false
  end
  
  def reset_coupon!
    update_columns coupon_id: nil, coupon_code: nil, coupon_price: nil
  end
  
  
  private
  
  def price_changed?
    artist_price_changed? || customer_price_changed?
  end
  
  def reset_coupon_upon_offer
    if price_changed? && offered?
      reset_coupon!
    end
  end
  
end