require 'spec_helper'

describe Profile, :type => :model do

  context "disabled by admin" do
    
    it "cannot publish" do
      profile = FactoryGirl.create(:unpublished, admin_disabled_at: Time.now)
      expect(profile.published?).to be false

      profile.toggle!
      expect(profile.published?).to be false      
    end
    
  end
  
  it "auto assigns coordinates" do
    profile = FactoryGirl.create(:shakira)
    expect(profile.latitude).to be_present
    expect(profile.longitude).to be_present
  end
  
  it "toggles publish" do
    profile = FactoryGirl.create(:unpublished)
    expect(profile.published?).to be false

    profile.toggle!
      expect(profile.published?).to be true
  end
  
end