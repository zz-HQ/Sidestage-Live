require 'spec_helper'


describe Account::ProfilesController, :type => :controller do
  
  

  before(:each) do
    FactoryGirl.create(:genre_classic)
    FactoryGirl.create(:genre_pop)
    FactoryGirl.create(:genre_dj)
    FactoryGirl.create(:genre_country)
  end
  
  context "new" do
  
    it "redirects index to new" do
      sign_in(FactoryGirl.create(:user))
      get :index
      expect(response).to redirect_to(new_account_profile_path)    
    end    
    
    it "renders new" do
      sign_in(FactoryGirl.create(:user))
      get :new
      expect(response).to render_template(:new)
    end
    
    it "redirects new to preview" do
      profile = FactoryGirl.create(:profile)
      sign_in(profile.user)    
      get :new
      expect(response).to redirect_to(preview_account_profile_path(profile))
    end
  end
  
  it "gets basics" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)    
    get :basics, id: profile.to_param
    expect(response).to render_template(:basics)
  end

  it "patches basics" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)    
    put :basics, id: profile.to_param, profile: { solo: (!profile.solo).to_s }
    expect(response).to render_template(:basics)
  end

  it "gets pricing" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)    
    get :pricing, id: profile.to_param
    expect(response).to render_template(:pricing)
  end

  it "patches pricing" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)    
    put :pricing, id: profile.to_param, profile: { price: profile.price + 1 }
    expect(response).to render_template(:pricing)
  end

  it "gets description" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)
    get :description, id: profile.to_param
    expect(response).to render_template(:description)
  end

  it "patches description" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)
    put :description, id: profile.to_param, profile: { title: profile.title + " halo" }
    expect(response).to render_template(:description)
  end

  
end

