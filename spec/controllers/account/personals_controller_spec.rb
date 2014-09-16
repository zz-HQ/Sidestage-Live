require 'spec_helper'


describe Account::PersonalsController, :type => :controller do

  

  let (:user) { FactoryGirl.create(:user) }
  
  it "gets show" do
    sign_in(user)
    get :show
    expect(response).to render_template("show")
  end
  
  it "patches show" do
    sign_in(user)
    put :show, user: { full_name: "hallo man" } 
    expect(response).to render_template("show")
  end

  it "gets password" do
    sign_in(user)
    get :password
    expect(response).to render_template("password")
  end
  
  it "patches password" do
    sign_in(user)
    put :password, user: { current_password: "12345678", password: "87654321", password_confirmation: "87654321" } 
    expect(response).to render_template("password")
  end

  it "gets payment_details" do
    sign_in(user)
    get :payment_details
    expect(response).to render_template("payment_details")
  end
  
  it "gets bank_details" do
    user.profiles << FactoryGirl.create(:profile)
    sign_in(user)
    get :bank_details
    expect(response).to render_template("bank_details")
  end  

  it "put bank_details" do
    profile = FactoryGirl.create(:unpublished)
    sign_in(profile.user)
    put :bank_details, profile: { routing_number: "12345567", account_number: "122323", city: "Long Island"  }
    expect(response).to render_template("bank_details")
  end
  
  it "remove balanced bank account" do
    profile = FactoryGirl.create(:balanced)
    expect(profile.balanced_payoutable?).to be_truthy
    allow_any_instance_of(Profile).to receive(:fetch_balanced_bank_account) { val = "MOCK"; def val.unstore; true; end; val }

    sign_in(profile.user)
    delete :remove_bank_account
    
    expect(profile.reload.balanced_payoutable?).to be_falsy
    expect(profile.reload.routing_number).to be_nil
  end
  
  
end