module Deal::DealCoupon
  extend ActiveSupport::Concern
  
  included do
  end
  
  
  def coupon_applied?
    coupon_price.present?
  end
  
  def apply_coupon!(coupon)
    self.coupon_code = coupon.code
    self.coupon_price = coupon.surcharged_profile_price(profile)
    self.coupon_id = coupon.id
    save! validate: false
  end
  
  def reset_coupon!
    self.coupon = nil
    self.coupon_code = nil
    self.coupon_price = nil
    save! validate: false
  end
  
end