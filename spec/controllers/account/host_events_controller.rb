require 'spec_helper'

describe Account::HostEventsController, :type => :controller do
  
  it "gets new" do
    host = FactoryGirl.create(:quentin)
    sign_in(host)
    get :new
    expect(response).to render_template("new")
  end
  
  it "creates event" do
    host = FactoryGirl.create(:quentin)
    sign_in(host)
    post :create, event: { event_at: 1.day.from_now, genre: "Classic" }
    expect(response).to redirect_to(payment_account_host_event_path(assigns(:event)))
  end
  
  it "gets payment" do
    event = FactoryGirl.create(:event)
    sign_in(event.user)
    get :payment, id: event.to_param
    expect(response).to render_template("payment")
  end
  
  
end