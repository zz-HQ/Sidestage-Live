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
  
  
end