require 'spec_helper'


describe Account::ConversationsController, :type => :controller do
  
  
  
  let(:current_user) { FactoryGirl.create(:user) }
  
  it "renders index" do
    conversation = FactoryGirl.create(:message, current_user: current_user).conversation
    sign_in(conversation.sender)
    get :index
  end

  context "show" do
    
    it "renders show" do
      conversation = FactoryGirl.create(:message, current_user: current_user).conversation
      conversation.receiver.profiles << FactoryGirl.create(:gaga)      
      sign_in(conversation.sender)
      get :show, id: conversation.id
    end

    it "decrements receiver unread message counter" do
      conversation = FactoryGirl.create(:message, sender: current_user, current_user: current_user).conversation
      conversation.receiver.profiles << FactoryGirl.create(:gaga)
      expect(conversation.receiver.reload.unread_message_counter).to eq(1)      
      sign_in(conversation.receiver)
      
      get :show, id: conversation.id
      
      expect(conversation.receiver.reload.unread_message_counter).to eq(0)
    end
    
  end

  
end