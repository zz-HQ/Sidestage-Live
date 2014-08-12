class Account::MessagesController < Account::ResourcesController
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
  
  def show
    flash.keep
    if resource.conversation.receiver.artist?
      redirect_to artist_path(resource.conversation.receiver)
    else
      redirect_to account_conversation_path(resource.conversation)
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
    params.permit(message: [:body, :receiver_id])
  end 
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def build_resource
    super.tap do |resource|
      resource.current_user = current_user
      resource.receiver_id ||= params[:receiver_id]
    end
  end
  
end
