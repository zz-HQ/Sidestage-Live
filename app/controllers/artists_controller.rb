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
  defaults :resource_class => Profile, :instance_name => 'profile'
  actions :index, :show

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
    
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.page(params[:page] || 1))
  end  
  

end

