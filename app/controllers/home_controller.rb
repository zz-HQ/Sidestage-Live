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

  def accept_cookies
    cookies.permanent[:accepted] = true
    render inline: ""
  end

  def index
    respond_to do |wants|
      wants.html
      wants.html.mobile
    end
  end

  def homepage
    @profiles = Profile.featured.published.limit(3)
    respond_to do |wants|
      wants.html
      wants.html.mobile
    end

    
  end
  

  def create_subscriber
    @mailchimp_subscriber = MailchimpSubscriber.new(params[:mailchimp_subscriber])
    @mailchimp_subscriber.save

    respond_to do |wants|
      wants.js
      wants.js.mobile
      wants.js.old_browser
    end
  end

end
