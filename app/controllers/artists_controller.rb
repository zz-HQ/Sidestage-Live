class ArtistsController < ApplicationController

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  inherit_resources
  defaults :resource_class => Profile, :instance_name => 'profile'
  actions :index, :show, :new, :create

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
    
  def create
    build_resource
    if resource.valid?
      session[:profile] = permitted_params[:profile]
      redirect_to new_user_registration_path and return
    else
      render :new
    end
  end  
    
  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
    
  protected
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private

  
  def permitted_params
    params.permit(profile: [:tagline, :price, :description, :about, :city, :youtube, :style, :soundcloud, genre_ids: []])
  end
  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.page(params[:page] || 1))
  end  
  
  def build_resource
    super.tap do |profile|
      profile.user_id = -1
    end
  end

end

