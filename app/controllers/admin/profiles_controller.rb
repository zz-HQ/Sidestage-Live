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
    redirect_to collection_path
  end
    
end