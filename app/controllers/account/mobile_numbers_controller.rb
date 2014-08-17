class Account::MobileNumbersController < AuthenticatedController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  respond_to :html, :js
  helper_method :resource

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  before_filter :referral_check
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def update
    if resource.update_attributes(permitted_params)
      resource.send_otp_code
      flash.now[:notice] = t(:"flash.account.mobile_numbers.create.notice")
    end
    render :show
  end
  
  def confirm
    resource.update_attributes(permitted_params)
    if resource.mobile_nr_confirmed?
      flash.now[:notice] = t(:"flash.account.mobile_numbers.confirm.notice")
      if @coming_from_profile_completion.present?
        session[:coming_from_profile_completion] = nil
        redirect_to preview_account_profile_path(current_user.profile), notice: t(:"flash.account.mobile_numbers.completion_confirm.notice")
        return
      end
    end
    render :show
  end
  
  def destroy
    resource.reset_mobile_nr!
    redirect_to account_mobile_numbers_path
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
    params.require(:user_as_mobile_number).permit(:mobile_nr, :mobile_confirmation_code)
  end
    
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def resource
    @user ||= User::AsMobileNumber.find(current_user.id)
  end
  
  def referral_check
    if session[:coming_from_profile_completion].present? || request.referrer.to_s.include?("/profile_completion/") 
      session[:coming_from_profile_completion] = true
    end
    @coming_from_profile_completion = session[:coming_from_profile_completion]
  end
  
end