class Admin::ConversationsController < Admin::ResourcesController
  
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private

  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.having_no_deals.ordered_by_last_message.includes([:sender, :receiver]).page(params[:page] || 1))
  end  

  
end