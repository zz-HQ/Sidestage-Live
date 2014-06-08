class ApplicationController < ActionController::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  # Prevent CSRF attacks by raising an exception. For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Localizable
  
  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  before_action :detect_device_format
  
  before_filter :load_currency

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
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || account_root_path
  end

  def after_sign_out_path_for(resource)
    root_path
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
  
end
