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
    flash[:signup] = flash[:notice]
    flash.delete(:notice)
    assign_potential_profile(resource)
    after_registration_path_for(resource)
  end
  
  def after_inactive_sign_up_path_for(resource)
    assign_potential_profile(resource)
    after_registration_path_for(resource)
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:full_name, :newsletter_subscribed]
  end    

  def is_flashing_format?
    true
  end    

end

