require 'spec_helper'
require 'before_each_helper'

describe ArtistsController, :type => :controller do
  
  before_each
  
  
  it "displays all artists" do
    FactoryGirl.create(:shakira)
    FactoryGirl.create(:gaga)

    get :index

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