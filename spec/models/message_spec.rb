require 'spec_helper'

describe Message, :type => :model do
  
  describe "Validations" do

    # it "has valid Factory" do
    #   expect(FactoryGirl.build(:user_quentin)).to be_valid
    # end
    # 
    # it "is not valid without sender" do
    #   expect(FactoryGirl.build(:user_quentin, sender_id: nil)).to be_invalid
    # end
    # 
    # it "is not valid without valid receiver" do
    #   expect(FactoryGirl.build(:user_quentin, receiver_id: 99999)).to be_invalid
    # end
    # 
    # it "is not valid without receiver" do
    #   expect(FactoryGirl.build(:user_quentin, receiver_id: nil)).to be_invalid
    # end
    # 
    # it "is not valid without subject" do
    #   expect(FactoryGirl.build(:user_quentin, subject: nil)).to be_invalid
    # end
    # 
    # it "is not valid without body" do
    #   expect(FactoryGirl.build(:user_quentin, body: nil)).to be_invalid
    # end
    # 
    # it "is not valid without body" do
    #   expect(FactoryGirl.build(:user_quentin, body: nil)).to be_invalid
    # end

    
  end

  it "is not valid if not in thread" do
    FactoryGirl.build(:message)
    FactoryGirl.build(:user_bob)
  end  
  
end
