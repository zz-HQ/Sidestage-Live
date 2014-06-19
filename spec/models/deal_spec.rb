require 'spec_helper'

describe Deal, :type => :model do
  
  describe "Validations" do

    it "has valid Factory" do
      expect(FactoryGirl.build(:deal)).to be_valid
    end
    
    it "is not valid without profile id" do
      expect(FactoryGirl.build(:deal, profile_id: nil)).to be_invalid
    end
    
    it "is not valid without start date" do
      deal = FactoryGirl.build(:deal, start_at: nil)
      expect(deal).to be_invalid
      expect(deal.errors).to have_key(:start_at)
    end
    
    it "has initial state requested" do
      deal = FactoryGirl.create(:deal)
      expect(deal.requested?).to be(true)
    end
    
    it "is not valid without state transition at" do
      deal = FactoryGirl.create(:deal)
      expect(deal.state_transition_at).to be_present
    end
    
    it "is not valid without customer payment info" do
      deal = FactoryGirl.build(:deal, customer: FactoryGirl.build(:customer))
      expect(deal).to be_invalid
      expect(deal.errors).to have_key(:customer_id)
    end
    
  end

  describe "Callbacks" do
    
    it "assigns artis on creat" do
      deal = FactoryGirl.create(:deal)
      expect(deal.artist).to eq(deal.profile.user)
    end
    
    it "assigns conversation on creat" do
      deal = FactoryGirl.create(:deal)
      expect(deal.conversation).to be_present
    end
    
    
  end
  
  describe "States" do
    
    
  end
  
  
end
