class Admin::UsersController < Admin::ResourcesController
  
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def toggle_verification
    resource.update_attribute :verified, !resource.verified?
    redirect_to collection_path
  end
  
end