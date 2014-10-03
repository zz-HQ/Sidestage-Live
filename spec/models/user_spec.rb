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
    
    it "signs up from facebook" do
      facebook_hash = OmniAuth::AuthHash.new info: { name: 'f d', first_name: 'Phillip', last_name: 'Fry', email: 'f@f.com', image: "" }, extra: { raw_info: { birthday: "01/30/1981" } }
      user = User.from_omniauth(facebook_hash)
      expect(user.persisted?).to be_truthy
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
