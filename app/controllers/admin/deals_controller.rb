class Admin::DealsController < Admin::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  defaults :resource_class => Deal::AsAdmin, :instance_name => 'deal'
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def toggle_payout
    resource.toggle_payout!
    respond_to do |format|
      format.html{ redirect_to :back }
      format.js{}
    end
  end
  

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def collection
    query = end_of_association_chain.latest
    if params[:by_state].present?
      query = query.send(params[:by_state])
    end
    @deals ||= query.page(params[:page] || 1)
  end  
  
end