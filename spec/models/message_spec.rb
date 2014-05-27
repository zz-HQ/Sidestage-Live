require 'spec_helper'

describe Message, :type => :model do
  
  describe "Validations" do

    it { should validate_presence_of(:sender_id) }
    it { should validate_presence_of(:receiver_id) }
    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:body) }

    it "has valid Factory" do
      expect(FactoryGirl.build(:user_quentin)).to be_valid
    end

    it "is not valid without valid receiver" do
      expect(FactoryGirl.build(:user_quentin, receiver_id: 99999)).to be_invalid
    end

    it "is not valid if not in valid thread" do
      not_my_thread = FactoryGirl.create(:user_quentin)
      my_thread = FactoryGirl.build(:bob_user, thread_id: not_my_thread.id)
      expect(my_thread).to be_invalid
    end  
    
  end
  
  describe "Associations" do

    it { should belong_to(:sender) }
    
    it { should belong_to(:receiver) }
        
  end

  
end
