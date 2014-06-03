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
  
  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  before_action :detect_device_format
  
  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  protected
  
  

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  private
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
  
  def detect_device_format
    case request.user_agent
    when /iPad/i
      request.variant = :tablet
    when /iPhone/i
      request.variant = :phone
    when /Android/i && /mobile/i
      request.variant = :phone
    when /Android/i
      request.variant = :tablet
    when /Windows Phone/i
      request.variant = :phone
    end
  end  
end
