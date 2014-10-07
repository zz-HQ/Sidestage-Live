require 'feature_helper'

feature "deal coupon", js: true do
  
  include Warden::Test::Helpers
  Warden.test_mode!
  
  let(:current_user) { FactoryGirl.create(:user) }    
  
  it "renders error" do
    gaga = FactoryGirl.create(:gaga)
    login_as(current_user)
    
    visit artist_path(gaga, locale: nil)
    click_button "Book it"
    expect(page).to have_selector("#coupon_show", text: "Coupon")
  end
    
end
