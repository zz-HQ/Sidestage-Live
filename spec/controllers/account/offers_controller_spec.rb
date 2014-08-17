require 'spec_helper'


describe Account::OffersController, :type => :controller do
  
   
  
  describe "ajax" do

    it "proposes" do
      customer = FactoryGirl.create(:customer)
      profile = FactoryGirl.create(:profile)

      sign_in(profile.user)
      post :create, deal: { customer_id: customer.id, start_at: Time.now, price: 2000 }, format: "js"

      expect(assigns(:deal).proposed?).to be true
      expect(response).to render_template("create")
    end

  end
  
  
end