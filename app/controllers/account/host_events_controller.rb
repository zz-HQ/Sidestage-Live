class Account::HostEventsController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  defaults resource_class: Event, instance_name: 'event', collection_name: 'events'
  
  
  def create
    create! do |success, failure| 
       success.html{
         flash.delete(:notice)
         redirect_to payment_account_host_event_path(resource)
       }
    end 
  end
  
  def payment
    if request.post?
      
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
    params.permit(event: [:event_day, :event_time, :genre, :postal_code])
  end

end