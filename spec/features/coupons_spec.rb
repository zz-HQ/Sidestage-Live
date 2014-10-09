require 'feature_helper'

feature "coupon", js: true do
  
  include Warden::Test::Helpers
  Warden.test_mode!
  
  let(:current_user) { FactoryGirl.create(:user) }    
  
  context "deal coupons" do
    
    describe "Customer enters coupon on profile page" do
      
      it "renders error" do
        gaga = FactoryGirl.create(:gaga)
        login_as(current_user)
    
        visit artist_path(gaga, locale: :en)
        click_button "Book it"
        expect(page).to have_selector("#coupon_show", text: "Coupon")
    
        click_link "coupon_show"
        fill_in "coupon_code", with: "COUPON"
        click_button "coupon_apply"

        expect(page).to have_css("#coupon_failure", visible: true)
        expect(page).to have_css("#coupon_success", visible: false)
      end

      it "renders success" do
        gaga = FactoryGirl.create(:gaga)
        coupon = FactoryGirl.create(:coupon)
        login_as(current_user)
    
        visit artist_path(gaga, locale: :en)
        click_button "Book it"
        expect(page).to have_selector("#coupon_show", text: "Coupon")
    
        click_link "coupon_show"
        fill_in "coupon_code", with: coupon.code
        click_button "coupon_apply"

        expect(page).to have_css("#coupon_failure", visible: false)
        expect(page).to have_css("#coupon_success", visible: true)
      end

      
    end
    
  end
end
