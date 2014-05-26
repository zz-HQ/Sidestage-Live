class ArtistsController < ApplicationController

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  inherit_resources
  defaults :resource_class => User, :instance_name => 'user'
  actions :index, :show

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def show
    @profile = resource.profiles.first
    redirect_to collection_path and return if @profile.nil?
    show!
    
  end
  
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private

end

