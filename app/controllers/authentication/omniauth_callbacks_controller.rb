class Authentication::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    logger.debug { "------ facebook #{request.env["omniauth.auth"]}" }
    if @user.persisted?
      assign_potential_profile(@user)
      store_location_for(:user, complete_pricing_account_profile_path(@user.profile)) if @user.profile.present?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      logger.debug { "--------------- START" }
      session.delete(stored_location_key_for(:user))
      logger.debug { "--------------- END" }
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
