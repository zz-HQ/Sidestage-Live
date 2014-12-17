require 'spec_helper'


describe Account::ProfilesController, :type => :controller do
  
  

  before(:each) do
    FactoryGirl.create(:genre_classic)
    FactoryGirl.create(:genre_pop)
    FactoryGirl.create(:genre_dj)
    FactoryGirl.create(:genre_country)
  end
  
  it "gets style" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)    
    get :style
    expect(response).to render_template(:style)
  end

  it "patches style" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)    
    patch :style, profile: { artist_type: 'dj' }, format: "js"
    expect(response).to render_template(:style)
  end

  it "gets geo" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)    
    get :geo
    expect(response).to render_template(:geo)
  end

  it "patches geo" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)    
    patch :geo, profile: { location: "Berlin", latitude: "123", longitude: "124", country_short: "123", country_long: "232" }, format: "js"
    expect(response).to render_template(:geo)
  end

  it "gets pricing" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)    
    get :pricing
    expect(response).to render_template(:pricing)
  end

  it "patches pricing" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)    
    patch :pricing, id: profile.to_param, profile: { price: profile.price + 1 }, format: "js"
    expect(response).to render_template(:pricing)
  end

  it "gets description" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)
    get :description
    expect(response).to render_template(:description)
  end

  it "patches description" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)
    patch :description, profile: { title: profile.title + " halo" }
    expect(response).to render_template(:description)
  end
  
  it "gets avatar" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)
    get :avatar
    expect(response).to render_template(:avatar)
  end

  it "uploads avatar" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)
    patch :avatar, profile: { avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'images', 'example.jpg')) }
    expect(response).to render_template(:avatar)
    expect(assigns(:profile).has_avatar?).to be(true)
  end
  

  it "patches youtube" do
    profile = FactoryGirl.create(:profile)
    request.env["HTTP_REFERER"] = preview_account_profile_path(profile)    
    sign_in(profile.user)
    patch :music, profile: { youtube: "hi" }
    expect(response).to render_template(:music)
  end

  it "patches soundcloud" do
    profile = FactoryGirl.create(:profile)
    request.env["HTTP_REFERER"] = preview_account_profile_path(profile)        
    sign_in(profile.user)
    patch :music, profile: { soundcloud: "hi" }
    expect(response).to render_template(:music)
  end
  
  it "removes soundcloud" do
    profile = FactoryGirl.create(:profile)
    request.env["HTTP_REFERER"] = preview_account_profile_path(profile)        
    sign_in(profile.user)
    put :remove_soundcloud

    expect(assigns(:profile).has_soundcloud?).to be(false)
    expect(response).to redirect_to(preview_account_profile_path(profile))
  end

  it "removes youtube" do
    profile = FactoryGirl.create(:profile)
    request.env["HTTP_REFERER"] = preview_account_profile_path(profile)            
    sign_in(profile.user)
    put :remove_youtube

    expect(assigns(:profile).has_youtube?).to be(false)    
    expect(response).to redirect_to(preview_account_profile_path(profile))
  end

  it "gets preview" do
    profile = FactoryGirl.create(:profile)
    sign_in(profile.user)
    get :preview
    expect(response).to render_template(:preview)
  end
  
end

