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
  
  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  before_action :detect_device_format, :auth_production, :set_ajax_layout
  before_filter :store_location, :load_currency

  #
  # Helpers
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  helper_method :current_currency, :old_browser?
  
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
    current_user.profile.present? ? preview_account_profile_path(current_user.profile) : (stored_location_for(resource) || root_path)
  end

  def after_sign_out_path_for(resource)
    root_path
  end
  
  def store_location
    store_location_for(:user, params[:return_to]) if params[:return_to].present?
  end
  
  def old_browser?
    browser.ie? && browser.version.to_i <= 9
  end
  
  def detect_device_format
    request.variant = :mobile if browser.mobile?
    request.variant = :tablet if browser.tablet?
    request.variant = :old_browser if old_browser?
  end  

  def load_currency
    @current_currency ||= Currency.where(name: session[:currency] || Rails.configuration.default_currency).first
  end

  def set_ajax_layout
    if request.headers['X-Lightbox'].present? || controller_name == 'home'
      self.class.layout false
    else
      self.class.layout "application"
    end
  end
  
end
