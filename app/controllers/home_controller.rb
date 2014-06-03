class HomeController < ApplicationController
  layout false

  def index
    respond_to do |wants|
      wants.html
      wants.html.phone
    end
  end

  def create_subscriber
    # mailchimp_api = Gibbon::API.new

    # res = mailchimp_api.lists.batch_subscribe(id: ENV['MAILCHIMP_LIST_ID'], double_optin: false, batch: [{email: {email: params[:subscriber][:email]}}])

    # @success = res['add_count'] > 0
    # @already_exists = res['errors'].first['code'] == 214 unless @success

    @success = true

    respond_to do |wants|
      wants.js
      wants.js.mobile
    end
  end

end
