class Authentication::RegistrationsController < Devise::RegistrationsController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  
  before_action :configure_permitted_parameters

  helper_method :after_sign_up_path_for
  
  respond_to :html, :js
  
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
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name, :newsletter_subscribed]
  end    

  def is_flashing_format?
    true
  end    

end

