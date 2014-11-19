require 'spec_helper'


describe ArtistsController, :type => :controller do
  
  it "rejects scrapers" do
    get :index    
    expect(response).to redirect_to(root_path)
  end

  it "gets index for short location name" do
    shakira = FactoryGirl.create(:shakira)
    get :index, short_location: "berlin"
    
    expect(response.status).to eq(200)
  end

  it "gets index for coordinates" do
    shakira = FactoryGirl.create(:shakira)
    get :index, lat: AVAILABLE_LOCATIONS[:berlin][:lat], lng: AVAILABLE_LOCATIONS[:berlin][:lng]
    
    expect(response.status).to eq(200)
  end
  
  it "rejects scrapper" do
    shakira = FactoryGirl.create(:shakira)
    get :index, lat: AVAILABLE_LOCATIONS[:berlin][:lat]
    
    expect(response).to redirect_to(root_path)
  end
  
  it "redirects to new city launch" do
    get :index, lat: AVAILABLE_LOCATIONS[:berlin][:lat], lng: AVAILABLE_LOCATIONS[:berlin][:lng]
    
    expect(response).to redirect_to(new_city_launch_path)
  end
  
  it "gets show" do
    shakira = FactoryGirl.create(:shakira)
    get :show, id: shakira.to_param    
    expect(response.status).to be(200)
  end
  
  context "pagination" do

    # it "displays next artist link" do
    #   gaga = FactoryGirl.create(:gaga)
    #   shakira = FactoryGirl.create(:shakira)
    # 
    #   get :show, id: gaga.to_param, column: :price, order: :asc
    # 
    #   expect(assigns(:next_resource)).to eq(shakira)
    #   expect(response.body).to match(".next-artist")
    # end

    # it "displays prev artist link" do
    #   gaga = FactoryGirl.create(:gaga)
    #   shakira = FactoryGirl.create(:shakira)
    # 
    #   get :show, id: shakira.to_param, column: :price, order: :asc
    # 
    #   expect(assigns(:prev_resource)).to eq(gaga)
    #   expect(response.body).to match(".prev-artist")
    # end
    
  end


end