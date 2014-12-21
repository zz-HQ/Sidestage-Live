class Account::PicturesController < Account::ResourcesController
 
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  respond_to :html, :js

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 
  
  before_filter :ensure_parent_exists

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create
    set_resource_ivar(begin_of_association_chain.pictures.create! picture: params[:file])
  end
  
  def destroy
    #needed to properly unset profile pictures step
    begin_of_association_chain.pictures.destroy(resource)
  end
  
  def sort
    resource.update_attribute :position, params[:position].to_i
    render inline: ""
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
    params.permit(picture: [:file, :caption, :position])
  end

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  
  def begin_of_association_chain
    @profile ||= current_user.profile
  end
  
  def ensure_parent_exists
    redirect_to style_account_profile_path if begin_of_association_chain.nil?
  end
  
end
