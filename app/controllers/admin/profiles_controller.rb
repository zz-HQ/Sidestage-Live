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

  def toggle_featured
    resource.toggle_featured!
    redirect_to :back
  end
  
  def tags
    resource.tag_list = permitted_params[:profile][:tag_list]
    resource.save validate: false
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
    params.permit(profile: [:tag_list])
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
    get_collection_ivar || set_collection_ivar(end_of_association_chain.joins(:user).includes(:user).sorty(params).latest.page(params[:page] || 1))
  end  


    
end