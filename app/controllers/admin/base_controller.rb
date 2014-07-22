class Admin::BaseController < ApplicationController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  http_basic_authenticate_with :name => "sidestage", :password => "air$music!" 
  
  layout 'admin'

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
end