module Conversationable
  extend ActiveSupport::Concern
  
  included do

    belongs_to :conversation
  
    def attach_to_conversation
      self.conversation ||= current_user.conversations.by_user(partner_id).first || create_conversation
    end

    def create_conversation
      conversation = Conversation.new
      conversation.sender_id = current_user.id
      conversation.receiver_id = partner_id
      conversation.body = body
      conversation.last_message_at = Time.now
      conversation.save
      conversation
    end  
  
  end
  

end