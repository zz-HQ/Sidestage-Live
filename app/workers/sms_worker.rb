class SmsWorker
  include Sidekiq::Worker
  
  sidekiq_options queue: :critical, retry: 2, :backtrace => true
  
  def perform(user_id, message)
    user = User.find user_id
    return if user.nil? || user.mobile_nr.blank?
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_token
    begin
      client.account.sms.messages.create from: Rails.application.secrets.twilio_from, to: user.mobile_nr, body: message
    rescue Twilio::REST::RequestError => e
      User.where(id: user_id).update_all(error_log: e.inspect)
    end
      
  end
  
end