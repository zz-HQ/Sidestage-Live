class Authentication::SessionsController < Devise::SessionsController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  respond_to :html, :js
  
  helper_method :after_sign_in_path_for



  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def is_flashing_format?
    action_name == "destroy" ? false : super
  end

end

