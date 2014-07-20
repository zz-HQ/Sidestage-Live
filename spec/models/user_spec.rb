require 'spec_helper'

describe User, :type => :model do
  
  describe "Validations" do
    
    it "has a valid Factory" do
      expect(FactoryGirl.create(:user)).to be_valid
    end
  
  end
  
  context "Authentication"  do
    
    it "has secret key" do
      user = FactoryGirl.build(:user)
      expect(user.otp_secret_key).to be_nil
      
      user.save
      
      expect(user.otp_secret_key).to be_present
    end
    
  end
  
  describe "Associations" do

    let(:current_user) { FactoryGirl.create(:user) }
    
    it "has many sent and received messages" do
      message = FactoryGirl.create(:user_quentin, current_user: current_user)
      reply = FactoryGirl.create(:user_quentin, current_user: message.receiver, sender: message.receiver, receiver: message.sender)
      expect(message.sender.messages).to eq([message, reply])
    end
    
  end
  

  
end
