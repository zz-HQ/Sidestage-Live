class Authentication::RegistrationsController < Devise::RegistrationsController

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_action :configure_permitted_parameters  
  
  
  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  protected 

  def after_sign_up_path_for(resource)
    assign_potential_profile
    root_path
  end
  
  def after_inactive_sign_up_path_for(resource)
    assign_potential_profile
    root_path
  end
  
  def assign_potential_profile
    if session[:profile].present?
      profile = Profile.new(session[:profile]) 
      resource.profiles << profile
      session[:profile] = nil
    end
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
  end    
    
end