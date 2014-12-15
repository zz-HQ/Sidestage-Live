class ApplicationController < ActionController::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  include Localizable
  
  # Prevent CSRF attacks by raising an exception. For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  layout :set_layout
  
  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  before_action :detect_device_format
  before_filter :store_location, :load_currency

  #
  # Helpers
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  helper_method :current_currency, :old_browser?, :profile_in_session?
  
  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  protected
  
  def current_currency
    @current_currency
  end

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  private

  def auth_production
    if controller_name != "home" && Rails.env.production?
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['HTTP_AUTH_NAME'] && password == ENV['HTTP_AUTH_PASSWORD']
      end 
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || (current_user.profile.present? ? preview_account_profile_path : root_path)
  end

  def after_sign_out_path_for(resource)
    home_path
  end 
  
  def store_location
    store_location_for(:user, params[:return_to]) if params[:return_to].present?
  end
  
  def assign_potential_profile(user)
    if session[:profile].present?
      profile = Profile::AsSignup.new(session[:profile])
      user.profiles << profile
      session[:profile] = nil
    end
  end
  
  def profile_in_session?
    session[:profile].present?
  end
  
  def old_browser?
    browser.ie? && browser.version.to_i <= 9
  end
  
  def detect_device_format
    request.variant = :mobile if browser.mobile?
    request.variant = :tablet if browser.tablet?
    request.variant = :old_browser if old_browser?
  end 
  
  def user_currency
    current_user && current_user.profile.try(:currency)
  end

  def load_currency
    @current_currency ||= Currency.where(name: session[:currency] || user_currency || Rails.configuration.default_currency).first
  end
  
  def lightbox_request?
    request.headers['X-Lightbox'].present?
  end
  
  def set_layout
    return false if lightbox_request? || controller_name == 'home'
    return "application"
  end
  
  def sidestage_store_location_for(key)
    session["#{key}_return_to"] = request.path
  end
  
  def sidestage_get_stored_location_for(key)
    session.delete("#{key}_return_to")
  end
  
end
