require 'spec_helper'

describe Authentication::OmniauthCallbacksController, :type => :controller do
  
  let(:facebook_hash) { OmniAuth::AuthHash.new info: { name: 'f d', first_name: 'Phillip', last_name: 'Fry', email: 'suff@suff.com', image: "" } }
  let(:genre) { FactoryGirl.create(:genre_classic) }

  before(:all) do
    Sidekiq::Testing.fake!
  end
  
  before(:each) do 
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = facebook_hash
  end
  
  it "signs up from facebook" do
    expect { get :facebook }.to change(User, :count).by(1)
  end
  
  it "assigns profile from session" do
    session[:profile] = { solo: true, location: "Berlin", genre_ids: [genre.id] }
    expect { get :facebook }.to change(Profile, :count).by(1)
  end
  
  it "subscribes to newsletter" do
    expect { get :facebook }.to change(MailchimpWorker.jobs, :size).by(1)
  end
  
end