class Account::OutgoingMessagesController < Account::ResourcesController
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  defaults resource_class: Message, instance_name: 'message'
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
    # create! { account_conversations_path }
    @message = current_user.messages.new permitted_params[:message]
    @message.sender = current_user

    respond_to do |wants|
      if @message.save
        wants.html { redirect_to account_conversation_path(@message.conversation), notice: "Message has been delivered" }
        wants.js {}
      else
        wants.html { redirect_to account_conversations_path, alert: "Error while sending message" }
        wants.js {}
      end
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
    params.permit(message: [:body, :receiver_id, :conversation_id])
  end 
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def end_of_association_chain
    begin_of_association_chain.outgoing_messages
  end
  
  def build_resource
    super.tap do |resource|
      resource.receiver_id ||= params[:receiver_id]
    end
  end
  
end
