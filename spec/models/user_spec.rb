require 'spec_helper'

describe User, :type => :model do
  
  describe "Validations" do
    
    it { should validate_presence_of(:email) }
    
    it "has a valid Factory" do
      expect(FactoryGirl.create(:user)).to be_valid
    end
  
  end
  
  describe "Associations" do

    # it { should have_many(:received_booking_requests) }
    # it { should have_many(:sent_booking_requests) }
    # it { should have_many(:received_booking_offers) }
    # it { should have_many(:sent_booking_offers) }

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
