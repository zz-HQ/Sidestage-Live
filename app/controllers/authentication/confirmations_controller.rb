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
    sign_in(resource_name, resource)
    resource.artist? ? pricing_account_profile_path : (sidestage_get_stored_location_for(:visitor_location) || complete_account_personal_path)
  end
    
end