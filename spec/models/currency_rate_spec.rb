require 'spec_helper'

describe CurrencyRate, :type => :model do

  describe "Validations" do

    it "has valid Factory" do
      expect(FactoryGirl.build(:eur_usd)).to be_valid
    end

    it "is not valid without rate" do
      expect(FactoryGirl.build(:eur_usd, rate: nil)).to be_invalid
    end

    it "is not valid without rate_from" do
      expect(FactoryGirl.build(:eur_usd, rate_from: nil)).to be_invalid
    end

    it "is not valid without rate_to" do
      expect(FactoryGirl.build(:eur_usd, rate_to: nil)).to be_invalid
    end
    
  end
  
end
