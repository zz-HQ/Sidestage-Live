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
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  def message_notification(message)
    @message = message
    mail(to: message.receiver.email, subject: "New Message") do |format|
      format.text
      format.html
    end
  end          
          
end
