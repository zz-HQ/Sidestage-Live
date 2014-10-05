class Admin::CouponsController < Admin::ResourcesController
  
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def destroy
    destroy! do |success, failure|
      success.html{ redirect_to :back }
    end
  end
  
  def toggle_activation
    resource.update_attribute :active, !resource.active?
    redirect_to :back 
  end
  
end