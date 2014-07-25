class Admin::ResourcesController < Admin::BaseController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  inherit_resources
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.latest.page(params[:page] || 1))
  end  
    
end