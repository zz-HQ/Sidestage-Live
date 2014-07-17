class Account::OffersController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 

  defaults :resource_class => Deal, :collection_name => 'deals', :instance_name => 'deal'  

  respond_to :html, :js

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create
    create! do |success, failure|
      success.html{ redirect_to account_conversation_path(resource.conversation) }
    end
  end
    
  
  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
    
  protected
  
  def permitted_params
    params.permit(deal: [:start_at, :price, :customer_id])
  end
    
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private

  def build_resource
    super.tap do |deal|
      deal.current_user = current_user
      deal.profile = current_user.profile
      deal.artist = current_user
      deal.state = :proposed
    end
  end
    
end