require 'spec_helper'
require 'before_each_helper'

describe Account::DealsController, :type => :controller do
  
  before_each 
  
  context "Payment" do
    
    describe "ajax" do
      
      describe "payment info missing" do

        it "initial request renders form" do
          customer = FactoryGirl.create(:customer)
          profile = FactoryGirl.create(:profile)
          expect(customer).to_not be_paymentable

          sign_in(customer)
          post :create, deal: { profile_id: profile.id, start_at: Time.now }, format: "js"

          expect(response).to render_template("create")
          expect(response).to render_template(partial: "_form")
        end
      end

      describe "payment info available" do

        it "creates deal" do
          customer = FactoryGirl.create(:quentin)
          profile = FactoryGirl.create(:profile)
          
          sign_in(customer)
          post :create, deal: { profile_id: profile.id, start_at: Time.now }, format: "js"
          
          expect(response).to render_template("create")
          expect(response).to render_template(partial: "_form", count: 0)
        end
      end
      
      
      
    end
    
  end

  
end