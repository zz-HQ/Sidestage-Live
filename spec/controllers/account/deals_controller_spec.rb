require 'spec_helper'


describe Account::DealsController, :type => :controller do
  
  context "states" do
    
    before(:each) do
    end

    it "offers" do
      deal = FactoryGirl.create(:requested_deal)
      
      sign_in(deal.artist)
      put :offer, id: deal.to_param, deal: { artist_price: 1000 }

      expect(assigns(:deal).offered?).to be true
      expect(assigns(:deal).artist_price).to be 1000
      expect(assigns(:deal).customer_price).to be 1200
      expect(response).to redirect_to(account_conversation_path(deal.conversation))
    end
    
    it "accepts" do
      deal = FactoryGirl.create(:requested_deal)
      mock_balanced_card      
      
      sign_in(deal.artist)
      put :accept, id: deal.to_param

      expect(assigns(:deal).accepted?).to be true
      expect(response).to redirect_to(account_conversation_path(deal.conversation))
    end

    it "confirms" do
      deal = FactoryGirl.create(:offered_deal)
      mock_balanced_card

      sign_in(deal.customer)
      put :confirm, id: deal.to_param
      
      expect(assigns(:deal).confirmed?).to be true
      expect(response).to redirect_to(account_conversation_path(deal.conversation))      
    end
    
    it "declines" do
      deal = FactoryGirl.create(:requested_deal)
      
      sign_in(deal.artist)
      put :decline, id: deal.to_param
      
      expect(assigns(:deal).declined?).to be true
      expect(response).to redirect_to(account_conversation_path(deal.conversation))      
    end
    
    it "rejects" do
      deal = FactoryGirl.create(:confirmed_deal)
      
      sign_in(deal.artist)
      put :reject, id: deal.to_param
      
      expect(assigns(:deal).rejected?).to be true
      expect(response).to redirect_to(account_conversation_path(deal.conversation))      
    end

    it "cancels" do
      deal = FactoryGirl.create(:confirmed_deal)
      
      sign_in(deal.customer)
      put :cancel, id: deal.to_param
      
      expect(assigns(:deal).cancelled?).to be true
      expect(response).to redirect_to(account_conversation_path(deal.conversation))      
    end
    
    
  end
  
  
  context "Actions" do
    
    it "double checks" do
      customer = FactoryGirl.create(:quentin)
      profile = FactoryGirl.create(:profile)
    
      sign_in(customer)
      post :double_check, deal: { profile_id: profile.id, start_at: Time.now }, format: "js"
    
      expect(response).to render_template("double_check")
      expect(response).to render_template(partial: "_form")
    end
    
  end
  
  
  context "Payment" do
    
      describe "payment info missing" do

        describe "ajax" do

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
        
        it "shows credit form dialog if confirming" do
          deal = FactoryGirl.create(:proposed_deal, customer: FactoryGirl.create(:customer))
          sign_in(deal.customer)
          
          put :confirm, id: deal.to_param
          
          expect(response).to redirect_to(account_conversation_path(deal.conversation))
          expect(flash[:show_credit_card_form]).to be true
        end

      end

      describe "payment info available" do
      
        describe "ajax" do
      
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