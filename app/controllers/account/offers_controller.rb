class Account::OffersController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 

  defaults resource_class: Deal, instance_name: 'deal'
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
  
  def permitted_params
    params.permit(deal: [:parent_deal_id, :price, :note])
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