class Authentication::ConfirmationsController < Devise::ConfirmationsController

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  
  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  protected 

  def after_confirmation_path_for(resource_name, resource)
    store_location_for(resource_name, complete_account_profile_path(resource.profiles.first)) if resource.profiles.first.present?
    if signed_in?(resource_name)
      stored_location_for(resource_name) || signed_in_root_path(resource)
    else
      new_session_path(resource_name)
    end
  end
    
end