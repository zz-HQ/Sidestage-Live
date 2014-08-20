class Account::ConversationMessagesController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  defaults :resource_class => Message, :collection_name => 'messages', :instance_name => 'message'  

  belongs_to :conversation

  actions :index

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  respond_to :html, :js
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
    
  protected
  

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
    
  private
  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.latest.page(params[:page]||0))
  end

end