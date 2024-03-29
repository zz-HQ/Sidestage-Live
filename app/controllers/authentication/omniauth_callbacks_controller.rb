class Authentication::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    logger.debug { "------ facebook #{request.env["omniauth.auth"]}" }
    if @user.persisted?
      had_profile = @user.profile.present?
      assign_potential_profile(@user)
      store_location_for(:user, pricing_account_profile_path) if !had_profile && @user.profile.present?
      if @user.new_fb_signup == true
        @user.subscribe_to_newsletter
        @user.notify_admin
        flash[:facebook_conversion_code] = true
      end
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
