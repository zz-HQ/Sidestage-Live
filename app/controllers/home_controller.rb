class HomeController < ApplicationController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  layout false


  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  skip_before_filter :load_currency, only: [:change_currency]
  
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def change_currency
    currency = Currency.where(name: params[:currency].upcase).first
    if currency.present?
      session[:currency] = currency.name
    end
    redirect_to :back
  end

  def change_locale
    locale = params[:lang]
    session[:locale] = locale
    redirect_to request.referer.present? ? request.referer : root_path(locale: locale)
  end


  def index
    respond_to do |wants|
      wants.html
      wants.html.mobile
    end
  end
  

  def create_subscriber
    mailchimp_api = Gibbon::API.new

    res = mailchimp_api.lists.batch_subscribe(id: Rails.application.secrets.mailchimp_list_id, double_optin: false, batch: [{email: {email: params[:subscriber][:email]}}])

    @success = res['add_count'] > 0
    @already_exists = res['errors'].first['code'] == 214 unless @success

    # @success = false

    respond_to do |wants|
      wants.js
      wants.js.mobile
      wants.js.old_browser
    end
  end

end
