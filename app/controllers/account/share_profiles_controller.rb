class Account::ShareProfilesController < AuthenticatedController

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

  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  def create
    current_user.profile.friends_emails = permitted_params[:emails]
    current_user.profile.share_with_friends!
    respond_to do |format|
      format.html{
        flash[:notice] = "Invitation sent!"
        redirect_to :back
      }
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
    params.require(:friends).permit(:emails)
  end

end