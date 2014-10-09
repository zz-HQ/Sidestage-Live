require 'feature_helper'

feature "coupon", js: true do
  
  include Warden::Test::Helpers
  Warden.test_mode!
  
  let(:current_user) { FactoryGirl.create(:user) }    
  
  context "deal coupons" do
    
    describe "Customer enters coupon on profile page" do
      
      # it "renders error" do
      #   gaga = FactoryGirl.create(:gaga)
      #   login_as(current_user)
      #     
      #   visit artist_path(gaga, locale: :en)
      #   click_button "Book it"
      #       
      #   click_link "coupon_show"
      #   fill_in "coupon_code", with: "COUPON"
      #   click_button "coupon_apply"
      # 
      #   expect(page).to have_css("#coupon_failure", visible: true)
      #   expect(page).to have_css("#coupon_success", visible: false)
      # end

      it "renders success" do
        gaga = FactoryGirl.create(:gaga)
        coupon = FactoryGirl.create(:coupon)
        login_as(current_user)
    
        visit artist_path(gaga, locale: :en)
        click_button "Book it"
        
        find(:xpath, "//a[contains(@data-coupon, 'show')]").click()
        find(:xpath, "//input[contains(@data-coupon, 'code')]").fill_in with: coupon.code}
#        click_link "[data-coupon='show']"
#        fill_in "//input[contains(@data-coupon, 'code')]", with: coupon.code
#        fill_in "[data-coupon=code]", with: coupon.code
        click_button "coupon_apply"

        expect(page).to have_css("[data-coupon=failure]", visible: false)
        expect(page).to have_css("[data-coupon=success]", visible: true)
      end

      
    end
    
  end
end
