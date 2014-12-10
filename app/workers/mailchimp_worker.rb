class MailchimpWorker
  include Sidekiq::Worker
  
  sidekiq_options retry: 2
  
  def perform(method, params)
    send(method, params)
  end
  
  def subscribe_user(user_id)
    user = User.find user_id
    return if user.nil?
    newsletter_id = user.artist? ? Rails.application.secrets.mailchimp_artist_id : Rails.application.secrets.mailchimp_customer_id
    mailchimp_api = Gibbon::API.new
    mailchimp_api.lists.batch_subscribe(id: newsletter_id, double_optin: false, batch: [ { email: { email: user.email }, merge_vars: { :FNAME => user.full_name, :LNAME => "" } } ])
    mailchimp_api.lists.batch_subscribe(id: Rails.application.secrets.mailchimp_newsletter_id, double_optin: true, batch: [ { email: { email: user.email }, merge_vars: { :FNAME => user.full_name, :LNAME => "" } } ])    
  end
  
  def subscribe(params)
    raise ArgumentError.new("param should be a hash of user info") unless params.is_a?(Hash)
    Gibbon::API.new.lists.batch_subscribe(id: params["list_id"], :double_optin => true, :batch => [{:email => {:email => params["email"]}, :merge_vars => {:FNAME => params["name"], :LNAME => ""}}])
  end
  
end