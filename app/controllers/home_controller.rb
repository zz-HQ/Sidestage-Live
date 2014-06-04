class HomeController < ApplicationController

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
  
end
