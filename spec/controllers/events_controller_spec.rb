require 'spec_helper'


describe EventsController, :type => :controller do
  
  it "gets show" do
    event = FactoryGirl.create(:event)
    get :show, id: event.to_param
    expect(response).to render_template("show")
  end

end