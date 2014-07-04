class ErrorsController < ApplicationController

  #
  # Error Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  def not_found
    render :status => 404
  end

  def unacceptable
    render :not_found, :status => 422
  end

  def internal_error
    render :status => 500
  end  
  
  def internal_server_error
    render :internal_error, :status => 500
  end
  
end