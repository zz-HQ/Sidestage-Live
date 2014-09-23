require 'spec_helper'


describe Account::ProfilesController, :type => :controller do
  
  

  before(:each) do
    FactoryGirl.create(:genre_classic)
    FactoryGirl.create(:genre_pop)
    FactoryGirl.create(:genre_dj)
    FactoryGirl.create(:genre_country)
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
    put :basics, id: profile.to_param, profile: { artist_type: 'dj' }
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

  it "gets preview" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)
    get :preview, id: profile.to_param
    expect(response).to render_template(:preview)
  end

  it "patches youtube" do
    profile = FactoryGirl.create(:profile)
    request.env["HTTP_REFERER"] = preview_account_profile_path(profile)    
    sign_in(profile.user)
    put :youtube, id: profile.to_param, profile: { youtube: "hi" }
    expect(response).to redirect_to(preview_account_profile_path(profile))
  end

  it "patches soundcloud" do
    profile = FactoryGirl.create(:profile)
    request.env["HTTP_REFERER"] = preview_account_profile_path(profile)        
    sign_in(profile.user)
    put :soundcloud, id: profile.to_param, profile: { soundcloud: "hi" }
    expect(response).to redirect_to(preview_account_profile_path(profile))
  end
  
  it "removes soundcloud" do
    profile = FactoryGirl.create(:profile)
    request.env["HTTP_REFERER"] = preview_account_profile_path(profile)        
    sign_in(profile.user)
    put :remove_soundcloud, id: profile.to_param
    expect(response).to redirect_to(preview_account_profile_path(profile))
  end

  it "removes youtube" do
    profile = FactoryGirl.create(:profile)
    request.env["HTTP_REFERER"] = preview_account_profile_path(profile)            
    sign_in(profile.user)
    put :remove_youtube, id: profile.to_param
    expect(response).to redirect_to(preview_account_profile_path(profile))
  end

  
end

