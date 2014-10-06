class CouponsController < ApplicationController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Index
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def apply_on_profile
    @coupon = Coupon.valid.active.where(code: params[:code]).first
    @profile = Profile.published.where(id: params[:profile_id]).first
    if @coupon.present? && @profile.present?
      coupon_price = CurrencyConverterService.convert(@coupon.amount, @coupon.currency, @profile.currency)      
      @new_price = @profile.price_with_surcharge - coupon_price
      @new_price = @new_price < 0 ? 0 : @new_price
    end
  end
  
end