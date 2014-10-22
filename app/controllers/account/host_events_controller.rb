class Account::HostEventsController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  defaults resource_class: Event, instance_name: 'event', collection_name: 'events'
  
  layout 'black'
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  def new
    build_resource
    resource.booking_for = session[:host_booking_for] if session[:host_booking_for].present?
    session[:host_booking_for] = nil
  end
  
  def create
    create! do |success, failure| 
       success.html{
         flash.delete(:notice)
         redirect_to payment_account_host_event_path(resource)
       }
    end 
  end
  
  def payment
    if request.patch?
      if resource.update_attributes(permitted_params[:event]||{}) && resource.charge_user!
        redirect_to confirmation_account_host_event_path(resource)
      end
    else
      redirect_to confirmation_account_host_event_path(resource) if resource.price < 1
    end
  end
  
  def confirmation
    if request.patch?
      if resource.update_attributes(permitted_params[:event])
        resource.notify_management
        redirect_to invite_friends_account_host_event_path(resource)
      end
    end
  end
  
  def invite_friends
    if request.patch?
      resource.friends_emails = permitted_params[:event][:friends_emails]
      resource.invite_friends!
      respond_to do |format|
        format.html{
          flash[:notice] = "Invitation sent!"
          redirect_to invite_friends_account_host_event_path(resource)
        }
        format.js{}
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
    params.permit(event: [:booking_for, :event_time, :event_at, :genre, :postal_code, :balanced_token, :address, :phone, :friends_emails, :coupon_code, :coupon_id])
  end

end