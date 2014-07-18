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
          
end
