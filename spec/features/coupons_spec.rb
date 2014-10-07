require 'spec_helper'

feature "deal coupon" do
  
  include Warden::Test::Helpers
  Warden.test_mode!
  
  let(:current_user) { FactoryGirl.create(:user) }    
  
  it "renders error" do
    gaga = FactoryGirl.create(:gaga)
    login_as(current_user)
    
    visit artist_path(gaga)
    click_button "Book it"
    
    expect(page).to have_selector("#coupon_show", text: "Coupon")
  end
    
end
