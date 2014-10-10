require 'feature_helper'

feature "coupon", js: true do
  
  include Warden::Test::Helpers
  Warden.test_mode!
  
  let(:current_user) { FactoryGirl.create(:user) }    
  
  context "deal coupons" do
    
    describe "Customer enters coupon on profile page" do
      
      it "shows error" do
        gaga = FactoryGirl.create(:gaga)
        login_as(current_user)
          
        visit artist_path(gaga, locale: :en)
        click_button "Book it"
            
        click_link "Coupon"
        fill_in "deal[coupon_code]", with: "C"
        click_button "coupon_apply"
      
        expect(page).to have_css("[data-coupon=failure]", visible: true)
        expect(page).to have_css("[data-coupon=success]", visible: false)
      end

      it "hides original price and shows coupon price" do
        gaga = FactoryGirl.create(:gaga)
        coupon = FactoryGirl.create(:coupon)
        login_as(current_user)
    
        visit artist_path(gaga, locale: :en)
        click_button "Book it"

        click_link "Coupon"
        fill_in "deal[coupon_code]", with: coupon.code
        click_button "coupon_apply"
        
        expect(page).to have_css("[data-coupon=original_price]", visible: false)
        expect(page).to have_css("[data-coupon=coupon_price]", visible: true)
      end

      
    end
    
  end
end
