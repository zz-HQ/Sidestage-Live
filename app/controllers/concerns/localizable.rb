module Localizable
  extend ActiveSupport::Concern
  
  included do
    before_filter :set_locale
  end
  
  def set_locale
    parsed_locale = param_locale || cookie_locale || domain_locale || accept_locale || I18n.default_locale
    locale_params = { :locale => parsed_locale }

    I18n.locale = parsed_locale
    cookies[:locale] = { :value => I18n.locale.to_s, :expires => 1.year.from_now }
  end

  def locale_available?(locale)
    I18n.available_locales.include?(locale.try(:to_sym))
  end

  def param_locale
    locale_available?(params[:locale]) ? params[:locale].try(:to_sym) : nil
  end

  def user_locale
    (user_signed_in? && current_user.locale_code.present? && locale_available?(current_user.locale_code)) ? current_user.locale_code.to_sym : nil
  end

  def cookie_locale
    (cookies.present? && cookies[:locale].present? && locale_available?(cookies[:locale])) ? cookies[:locale].try(:to_sym)  : nil
  end

  def domain_locale
    parsed_locale = request.host.split('.').last
    parsed_locale = ["uk", "com", "org", "net"].include?(parsed_locale) ? :en : parsed_locale.try(:to_sym)
    (locale_available?(parsed_locale)) ? parsed_locale  : nil
  end

  def accept_locale
    parsed_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first.try(:to_sym) unless request.env['HTTP_ACCEPT_LANGUAGE'].blank?
    (locale_available?(parsed_locale)) ? parsed_locale.try(:to_sym)  : nil
  end
  
  def default_url_options(options = {})
    options.merge(:locale => I18n.locale)
  end
    
end