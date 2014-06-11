require 'spec_helper'

describe Account::ConversationsController, :type => :controller do

  it "renders index" do
    conversation = FactoryGirl.create(:message).conversation
    sign_in(conversation.sender)
    get :index
  end

  context "show" do
    
    it "renders show" do
      conversation = FactoryGirl.create(:message).conversation
      sign_in(conversation.sender)
      get :show, id: conversation.id
    end

    it "decrements receiver unread message counter" do
      conversation = FactoryGirl.create(:message).conversation
      expect(conversation.receiver.unread_message_counter).to eq(1)      
      sign_in(conversation.receiver)
      
      get :show, id: conversation.id
      
      expect(conversation.receiver.reload.unread_message_counter).to eq(0)
    end
    
  end

  
end