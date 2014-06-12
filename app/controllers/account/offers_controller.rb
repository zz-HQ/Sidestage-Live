class Account::OffersController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 

  defaults resource_class: Deal, instance_name: 'deal'
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create
    create! do |success, failure|
      success.html { redirect_to account_conversation_path(resource.conversation) }
      failure.html { render :new }
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
    params.permit(deal: [:customer_id, :profile_id, :start_at, :price, :note])
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
    super.tap do |resource|
      resource.currency = current_currency.name
      resource.offer = true
    end
  end
  
end