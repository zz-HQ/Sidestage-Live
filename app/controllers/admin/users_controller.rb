class Admin::UsersController < Admin::ResourcesController
  
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def confirm
    resource.confirm!
    redirect_to :back  
  end
  
  def toggle_verification
    resource.update_attribute :verified, !resource.verified?
    redirect_to :back 
  end
  
end