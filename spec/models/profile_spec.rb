require 'spec_helper'

describe Profile, :type => :model do

  describe "Callbacks" do
    
    it "toggles publish" do
      profile = FactoryGirl.create(:unpublished)
      expect(profile.published?).to be false
      
      profile.toggle!
      expect(profile.published?).to be true
    end
    
  end
  
end