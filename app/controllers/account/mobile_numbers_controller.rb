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
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def update
    if resource.update_attributes(permitted_params)
      resource.send_otp_code
      flash.now[:notice] = "Verification code sent."
    end
    render :show
  end
  
  def confirm
    resource.update_attributes(permitted_params)
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
  
end