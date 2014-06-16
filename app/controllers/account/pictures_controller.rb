class Account::PicturesController < ApplicationController

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def index
    @pictures = current_user.profile.pictures
  end

  def create
  end

  def destroy
  end

end
