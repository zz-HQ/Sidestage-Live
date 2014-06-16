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

  # POST /resource/sign_in
  # def create
  #   if self.resource = warden.authenticate(auth_options)
  #     set_flash_message(:notice, :signed_in) if is_flashing_format?
  #     sign_in(resource_name, resource)
  #     yield resource if block_given?
  #     respond_with resource, location: after_sign_in_path_for(resource)
  #   else
  #     render template: "devise/sessions/new"
  #   end
  # end

end

