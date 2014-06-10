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
  
  describe "Associations" do

  end

  
end
