class ExpressBookingsController < ApplicationController  
  
  def index
    redirect_to new_account_host_event_path if current_user.present?
  end
  

end

