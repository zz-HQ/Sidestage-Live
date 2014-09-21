require 'spec_helper'

describe PaymentJob, :type => :model do
  
  context "payout" do
    
    it "pays out artists" do
      deal = FactoryGirl.create(:past_confirmed_charged_deal)
      expect(deal.balanced_payed_out?).to be false
      mock_balanced_bank_account
      
      PaymentJob.payout_artists
      
      expect(deal.reload.balanced_payed_out?).to be true
    end
    
  end
  
end
