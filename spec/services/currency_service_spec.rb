require 'spec_helper'

describe CurrencyService, :type => :model do
  
  let(:currency_service) { CurrencyService.new }
  let(:yahoo_usdeuro_rate) { {"id"=>"USDEUR", "Name"=>"USD to EUR", "Rate"=>"0.1", "Date"=>"6/4/2014", "Time"=>"9:19am", "Ask"=>"0.7339", "Bid"=>"0.7337"}  }
  
  
  before(:each) do
    FactoryGirl.create(:us_dollar)
    FactoryGirl.create(:euro)
  end  
  
  it "creates new currency rate" do
    expect(CurrencyRate.count).to eq(0)
    currency_service.update_currency_rate(Currency.first, Currency.last, yahoo_usdeuro_rate)
    expect(CurrencyRate.count).to eq(1)
  end

  it "updates existing rate" do
    currency_rate = FactoryGirl.create(:usd_eur)
    currency_service.update_currency_rate(Currency.where(name: "USD").first, Currency.where(name: "EUR").first, yahoo_usdeuro_rate.merge({"Rate" => 1111}))
    expect(CurrencyRate.count).to eq(1)
    expect(CurrencyRate.where(rate_from: "USD", rate_to: "EUR").first.rate).to eq(1111)
  end
  
  it "updates all currencies" do
    allow_any_instance_of(CurrencyService).to receive(:get_yahoo_rate).and_return(yahoo_usdeuro_rate)
    CurrencyService.update_all_rates
    expect(CurrencyRate.count).to eq(2)
    expect(CurrencyRate.first.rate).to eq(yahoo_usdeuro_rate["Rate"].to_f)
  end
  
  it "gets yahoo rate for dollar <-> euro" do
    rate = currency_service.get_yahoo_rate("USD", "EUR")
    expect(rate["Rate"].to_f).to be > 0
  end
  
end
