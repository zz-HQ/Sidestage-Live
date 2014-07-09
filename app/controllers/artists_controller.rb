class ArtistsController < ApplicationController
  
  include PageableResource

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_filter :reject_scraper, only: [:index]
  before_filter :redirect_if_unpublished, only: [:show]
  
  
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
  respond_to :html, :js
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create
    build_resource
    session[:profile] = permitted_params[:profile]
    render :new and return unless resource.valid?
    respond_to do |format|
      format.html{ redirect_to new_user_registration_path }
      format.js{}
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
    params.permit(profile: [:solo, :name, :location, :price, :title, :about, :city, :youtube, :style, :soundcloud, genre_ids: []])
  end
  
  def redirect_if_unpublished
    redirect_to artists_path unless resource.published?
  end
  
  def reject_scraper
    redirect_to root_path if params[:location].blank?
  end
  
  def collection
    get_collection_ivar || set_collection_ivar(resources.page(params[:page] || 1))
  end  
  
  def resources
    end_of_association_chain.filter(params).sorty(params).published
  end
  
  def build_resource
    super.tap do |profile|
      profile.user_id = -1
    end
  end

end

