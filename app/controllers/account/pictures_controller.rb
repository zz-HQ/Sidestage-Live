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
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create
    set_resource_ivar(current_user.profile.pictures.create! picture: params[:file])
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
    params.permit(picture: [:file, :caption])
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
    current_user.profile
  end
  
  
end
