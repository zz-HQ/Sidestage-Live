class Admin::CouponsController < Admin::ResourcesController
  
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def show
    redirect_to collection_path
  end
  
  def destroy
    destroy! do |success, failure|
      success.html{ redirect_to :back }
    end
  end
  
  def toggle_activation
    resource.update_attribute :active, !resource.active?
    redirect_to :back 
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
    params.permit(coupon: [:code, :amount, :currency, :description, :expires_at])
  end
    
end