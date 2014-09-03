class Admin::MessagesController < Admin::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  belongs_to :conversation, parent_class: Conversation, optional: true
  respond_to :html, :js
  
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
    get_collection_ivar || set_collection_ivar(end_of_association_chain.latest.non_system)
  end  
    
end