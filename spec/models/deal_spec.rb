require 'spec_helper'

describe Deal, :type => :model do

  before do
    clear_messages
  end

  describe "Validations" do

    it "has valid Factory" do
      expect(FactoryGirl.build(:deal)).to be_valid
    end
    
    it "is not valid without profile id" do
      expect(FactoryGirl.build(:deal, profile_id: nil)).to be_invalid
    end
    
    it "is not valid without start date" do
      deal = FactoryGirl.build(:deal, start_at: nil)
      expect(deal).to be_invalid
      expect(deal.errors).to have_key(:start_at)
    end
    
    it "has initial state requested" do
      deal = FactoryGirl.create(:deal)
      expect(deal.requested?).to be(true)
    end
    
    it "is not valid without customer payment info" do
      customer = FactoryGirl.create(:customer)
      deal = FactoryGirl.build(:deal, current_user: customer, customer: customer)
      expect(deal).to be_invalid
      expect(deal.errors).to have_key(:customer_id)
    end
    
  end

  describe "Callbacks" do
    
    it "sets state transition at" do
      deal = FactoryGirl.create(:deal)
      expect(deal.state_transition_at).to be_present
    end
        
    it "assigns artis on create" do
      deal = FactoryGirl.create(:deal)
      expect(deal.artist).to eq(deal.profile.user)
    end
    
    it "assigns conversation on create" do
      deal = FactoryGirl.create(:deal)
      expect(deal.conversation).to be_present
    end
    
  end
  
  context "SMS notifications" do
    
    it "Request sends sms to artist" do
      deal = FactoryGirl.create(:requested_deal)
      open_last_text_message_for(deal.artist.mobile_nr)
      expect(current_text_message.body).to include("You have a new booking request")      
    end

    it "Confirm sends sms to artist" do
      deal = FactoryGirl.create(:confirmed_deal)
      open_last_text_message_for deal.artist.mobile_nr
      expect(current_text_message.body).to include("is confirmed for")      
    end

    it "Confirm sends sms to customer" do
      deal = FactoryGirl.create(:confirmed_deal)
      open_last_text_message_for deal.customer.mobile_nr
      expect(current_text_message.body).to include("is confirmed for")      
    end

  end
  
  context "Payment" do

    context "customer chargeable" do

      it "charges customer on accept" do
        deal = FactoryGirl.create(:deal)
        deal.current_user = deal.artist
        expect(deal.customer).to be_paymentable
        
        mock_balanced_card
        
        deal.accept!
      
        expect(deal.accepted?).to be true
        expect(deal.balanced_debit_id).to eq("1234")
      end

      it "charges customer on confirm" do
        deal = FactoryGirl.build(:offered_deal)
        deal.artist = deal.profile.user
        deal.conversation = FactoryGirl.create(:conversation, sender_id: deal.artist_id, receiver_id: deal.customer_id)
        deal.save(validate: false)
        
        deal.current_user = deal.customer
        expect(deal.customer).to be_paymentable
        
        mock_balanced_card
        
        deal.confirm!
        expect(deal.confirmed?).to be true
        expect(deal.balanced_debit_id).to eq("1234")
      end

    
      it "does not charge twice" do
        deal = FactoryGirl.create(:deal, balanced_debit_id: "already_charged")
        deal.current_user = deal.artist
        expect(deal.customer).to be_paymentable
      
        deal.accept!
      
        expect(deal.accepted?).to be true
        expect(deal.reload.balanced_debit_id).to eq("already_charged")
      
      end
      
    end
    
    context "customer not chargeable" do
      
      it "proposes" do
        customer = FactoryGirl.create(:customer)
        expect(customer.paymentable?).to be false
        
        deal = FactoryGirl.create(:proposed_deal, customer: customer)
        
        expect(deal.proposed?).to be true
      end
      
      it "has error on customer_id upon confirming" do
        deal = FactoryGirl.create(:proposed_deal, customer: FactoryGirl.create(:customer))
        deal.current_user = deal.customer
        deal.confirm!

        expect(deal.proposed?).to be true
        expect(deal.errors).to have_key(:customer_id)
      end
      
    end
    
    context "charging fails" do
      
      it "does not change to accepted" do
        deal = FactoryGirl.create(:deal)
        expect(deal.customer).to be_paymentable
        allow(deal).to receive(:retrieve_balanced_card) { 
          e = Balanced::Error.new("Error")
          raise e
        }
        
        deal.accept!
      
        expect(deal.accepted?).to be false
        expect(deal.balanced_debit_id).to be_nil
      end
      
    end
    
  end
  
end
