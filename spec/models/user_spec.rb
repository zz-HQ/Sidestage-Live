require 'spec_helper'

describe User, :type => :model do
  
  describe "Validations" do
    
    it "has a valid Factory" do
      FactoryGirl.create(:user)
      FactoryGirl.create(:quentin)
      expect(FactoryGirl.create(:user)).to be_valid
    end
  
    it "is not valid without email" do
      expect(FactoryGirl.build(:user, email: nil)).to be_invalid
    end

  end
  
  describe "Associations" do

    it "has many sent messages" do
      message = FactoryGirl.create(:user_quentin)
      expect(message.sender.sent_messages).to eq([message])
      expect(message.sender.received_messages).to eq([])
    end

    it "has many received messages" do
      message = FactoryGirl.create(:user_quentin)
      expect(message.receiver.received_messages).to eq([message])
      expect(message.receiver.sent_messages).to eq([])      
    end

    it "has many sent and received messages" do
      message = FactoryGirl.create(:user_quentin)
      reply = FactoryGirl.create(:user_quentin, sender: message.receiver, receiver: message.sender)
      expect(message.sender.messages).to eq([message, reply])
    end
    
  end
  

  
end
