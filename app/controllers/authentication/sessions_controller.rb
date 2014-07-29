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

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  protected
  
  def require_no_authentication
    if lightbox_request? && current_user
      render inline: "<script>window.location = '#{after_sign_in_path_for(current_user)}';</script>"
    else
      super
    end
  end

end

