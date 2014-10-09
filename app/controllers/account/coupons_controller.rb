class Account::CouponsController < Account::ResourcesController
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def apply_on_profile
    @coupon = Coupon.valid.active.where(code: params[:code]).first
    @profile = Profile.published.where(id: params[:profile_id]).first
  end  
  
  def apply_on_deal
    @coupon = Coupon.valid.active.where(code: permitted_params[:coupon_code]).first
    @deal = current_user.deals.where(id: params[:deal_id]).first
    if @deal.present?
      if @coupon.present?
        @deal.apply_coupon!(@coupon)
      else
        @deal.reset_coupon!
      end
    end
  end  

  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  protected
  
  def permitted_params
    params.require(:deal).permit(:coupon_code)
  end
    
end