class Account::PicturesController < Account::ResourcesController
 
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  belongs_to :profile, :polymorphic => true
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
  
end
