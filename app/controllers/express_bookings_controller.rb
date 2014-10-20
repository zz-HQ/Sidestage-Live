class ExpressBookingsController < ApplicationController  

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  layout 'black'  

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def index
    redirect_to new_account_host_event_path if current_user.present?
  end
  
  def sign_up
    session[:host_booking_for] = permitted_params[:event][:booking_for]
    params[:return_to] = new_account_host_event_path
    store_location
    redirect_to user_omniauth_authorize_path(:facebook)
  end
  



  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def permitted_params
    params.permit(event: [:booking_for])
  end



end

