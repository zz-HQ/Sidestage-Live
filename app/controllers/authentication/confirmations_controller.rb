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
    resource.profiles.first.present? ? complete_account_profile_path(resource.profiles.first) : complete_account_personal_path
  end
    
end