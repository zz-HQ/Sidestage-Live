class ExpressBookingsController < ApplicationController  
  
  def index
    redirect_to new_account_host_event_path if current_user.present?
  end
  
  def sign_up
    session[:host_event_day] = permitted_params[:event][:event_day]
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
    params.permit(event: [:event_day])
  end



end

