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
  end
  
end