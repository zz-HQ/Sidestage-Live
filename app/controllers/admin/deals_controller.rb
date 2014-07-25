class Admin::DealsController < Admin::ResourcesController

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def collection
    query = end_of_association_chain
    if params[:by_state].present?
      query = query.send(params[:by_state])
    end
    @deals ||= query.page(params[:page] || 1)
  end  
  
end