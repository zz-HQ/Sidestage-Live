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
  
  it "toggles publish" do
    profile = FactoryGirl.create(:unpublished, wizard_state: Profile::WIZARD_STEPS.join(","))
    expect(profile.published?).to be false

    profile.toggle!
    expect(profile.published?).to be true
  end
  
end