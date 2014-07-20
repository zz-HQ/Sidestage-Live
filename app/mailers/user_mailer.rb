class UserMailer < Devise::Mailer

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  default :from => ENV["mail_from"],
          :reply_to => ENV["mail_from"],
          :return_path => ENV["mail_return_path"]
  
  layout "email/user"

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  after_filter :send_sms, only: [:message_notification]
    
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  def message_notification(message)
    @user = message.receiver
    @message = message
    mail(to: @user.email, subject: "New Message") do |format|
      format.text
      format.html
    end
  end
  
  def send_sms
    @user.send_sms("New message from Sidestage")
  end
  
end