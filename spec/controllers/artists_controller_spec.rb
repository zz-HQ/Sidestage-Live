require 'spec_helper'


describe ArtistsController, :type => :controller do
  
  
  
  
  it "rejects scrapers" do
    get :index    
    expect(response).to redirect_to(root_path)
  end
  
  it "gets index" do
    shakira = FactoryGirl.create(:shakira)
    FactoryGirl.create(:gaga)

    get :index, location: shakira.location
    
    expect(response.status).to eq(200)
  end
  
  context "pagination" do

    it "displays next artist link" do
      gaga = FactoryGirl.create(:gaga)
      shakira = FactoryGirl.create(:shakira)

      get :show, id: gaga.to_param, column: :price, order: :asc

      expect(assigns(:next_resource)).to eq(shakira)
      expect(response.body).to match(".next-artist")
    end

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