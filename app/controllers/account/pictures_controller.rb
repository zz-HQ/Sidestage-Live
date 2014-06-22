class Account::PicturesController < ApplicationController
  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  before_action :find_pictures

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  respond_to :html, :js
  
  def index
  end

  def create
    current_user.profile.pictures.create! picture: params[:file]
    render "update"
  end

  def destroy
    picture = current_user.profile.pictures.find params[:id]
    picture.destroy
    render "update"
  end


private

  def find_pictures
    @pictures = current_user.profile.pictures
  end
  
end
