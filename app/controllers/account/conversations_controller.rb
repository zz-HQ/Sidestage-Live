class Account::ConversationsController < AuthenticatedController
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  actions :index, :show
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def show
    @message = Message.new
    @message.receiver_id = resource.negotiator_for(current_user).id
    show!
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
  

end