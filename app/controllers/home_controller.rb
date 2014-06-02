class HomeController < ApplicationController
  layout false

  def index
    
  end

  def create_subscriber
    mailchimp_api = Gibbon::API.new
    @res = mailchimp_api.lists.batch_subscribe(id: ENV['MAILCHIMP_LIST_ID'], double_optin: false, batch: [{email: {email: params[:subscriber][:email]}}])

    respond_to do |wants|
      wants.js
    end
  end

end
