require 'spec_helper'

describe User, :type => :model do
  
  describe "Validations" do
    
    it "has a valid Factory" do
      expect(FactoryGirl.create(:user)).to be_valid
    end
  
  end
  
  describe "Associations" do

    let(:current_user) { FactoryGirl.create(:user) }
    
    it "has many sent messages" do
      message = FactoryGirl.create(:user_quentin, current_user: current_user)
      expect(message.sender.sent_messages).to eq([message])
      expect(message.sender.received_messages).to eq([])
    end

    it "has many received messages" do
      message = FactoryGirl.create(:user_quentin, current_user: current_user)
      expect(message.receiver.received_messages).to eq([message])
      expect(message.receiver.sent_messages).to eq([])      
    end

    it "has many sent and received messages" do
      message = FactoryGirl.create(:user_quentin, current_user: current_user)
      reply = FactoryGirl.create(:user_quentin, current_user: message.receiver, sender: message.receiver, receiver: message.sender)
      expect(message.sender.messages).to eq([message, reply])
    end
    
  end
  

  
end
