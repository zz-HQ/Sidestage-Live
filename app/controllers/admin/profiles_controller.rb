class Admin::ProfilesController < Admin::ResourcesController
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def toggle
    resource.toggle!
    redirect_to :back
  end
  
  def toggle_admin_disabled
    resource.toggle_admin_disabled!
    redirect_to :back
  end
    
end