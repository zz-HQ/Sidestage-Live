class Account::OutgoingMessagesController < AuthenticatedController
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  defaults :resource_class => Message, :instance_name => 'message'
  actions :new, :create  
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create
    create! { account_conversations_path }
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
    params.permit(message: [:subject, :body, :receiver_id, :thread_id])
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