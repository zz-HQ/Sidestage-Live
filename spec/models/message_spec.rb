require 'spec_helper'

describe Message, :type => :model do
  
  describe "Validations" do

    it "has valid Factory" do
      expect(FactoryGirl.build(:user_quentin)).to be_valid
    end

    it "is not valid without valid receiver" do
      expect(FactoryGirl.build(:user_quentin, receiver_id: nil)).to be_invalid
    end
    
  end
  
  describe "Callbacks" do
    
    it "increments receiver unread message counter" do      
      expect(FactoryGirl.build(:quentin_bob).receiver.unread_message_counter).to eq(0)
      expect(FactoryGirl.create(:quentin_bob).receiver.reload.unread_message_counter).to eq(1)
    end
    
  end
  
  describe "deliveries" do
    
    it "notifies receiver" do
      message = FactoryGirl.create(:user_quentin)
      expect(ActionMailer::Base.deliveries.last.to).to eq([message.receiver.email])
    end

    it "does not notify receiver for system message" do
      message = FactoryGirl.create(:system_message_quentin)
      expect(ActionMailer::Base.deliveries.map(&:to).flatten).to_not include(message.receiver.email)
    end
    
  end
  
end
