require 'spec_helper'
require 'before_each_helper'

describe HomeController, :type => :controller do
  
  before_each
  
  
  it "sets new currency in session" do
    FactoryGirl.create(:euro)
    request.env["HTTP_REFERER"] = "sidestage.dev"

    post :change_currency, currency: "EUR"

    expect(session[:currency]).to eq("EUR")
    expect(response).to redirect_to("sidestage.dev")    
  end
    
end
