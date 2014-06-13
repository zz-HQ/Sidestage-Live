require 'spec_helper'

describe Message, :type => :model do
  
  describe "Validations" do

    it "has valid Factory" do
      expect(FactoryGirl.build(:user_quentin)).to be_valid
    end

    it "is not valid without valid receiver" do
      expect(FactoryGirl.build(:user_quentin, receiver_id: 99999)).to be_invalid
    end
    
  end
  
  describe "Callbacks" do
    
    it "increments receiver unread message counter" do      
      expect(FactoryGirl.build(:quentin_bob).receiver.unread_message_counter).to eq(0)
      expect(FactoryGirl.create(:quentin_bob).receiver.reload.unread_message_counter).to eq(1)
    end
    
  end

  
end
