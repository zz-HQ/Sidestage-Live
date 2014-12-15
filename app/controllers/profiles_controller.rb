class ProfilesController < ApplicationController
  
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
  defaults :resource_class => Profile::AsSignup, :instance_name => 'profile'

  actions :new, :create
  
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
    session[:profile] = permitted_params[:profile_as_signup]
    render :new and return unless resource.valid?
    
    respond_to do |format|
      format.html{ redirect_to new_user_registration_path }
      format.js{
        redirect_to new_city_launch_path
      }
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
  
  def permitted_params
    params.permit(profile_as_signup: [:artist_type, :location, :longitude, :latitude, :country_long, :country_short, :style, genre_ids: []])
  end
  
  def build_resource
    super.tap do |profile|
      profile.user_id = -1
    end
  end  
  
end