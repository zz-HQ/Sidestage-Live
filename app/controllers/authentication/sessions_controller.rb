class Authentication::SessionsController < Devise::SessionsController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  prepend_before_filter :verify_user, only: [:destroy]

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

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  ## This method intercepts SessionsController#destroy action 
  ## If a signed in user tries to sign out, it allows the user to sign out 
  ## If a signed out user tries to sign out again, it redirects them to sign in page
  def verify_user
    ## redirect to appropriate path
    redirect_to new_user_session_path and return unless user_signed_in?
  end

end