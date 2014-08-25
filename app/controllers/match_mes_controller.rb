class MatchMesController < ApplicationController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  inherit_resources
  
  #
  # Index
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def index 
    build_resource   
  end
  
  def create
    build_resource
    if resource.valid?
      render :location
    else
      render :index
    end
  end
  
  def location
    build_resource
    resource.wizard_step = :location
    if resource.save
      render :thanks
    end
  end
  
end