class MailchimpWorker
  include Sidekiq::Worker
  
  sidekiq_options retry: 2
  
  def perform(user_id)
    user = User.find user_id
    return if user.nil?
    if user.newsletter_subscribed?
      newsletter_id = user.artist? ? Rails.application.secrets.mailchimp_artist_id : Rails.application.secrets.mailchimp_customer_id
      Rails.logger.debug { "newsletter: #{newsletter_id} set for user: #{user.id}" }
      mailchimp_api = Gibbon::API.new
      res = mailchimp_api.lists.batch_subscribe(id: newsletter_id, double_optin: false, batch: [ { email: { email: user.email }, merge_vars: { :FNAME => user.full_name, :LNAME => "" } } ])
    end
  end
  
end