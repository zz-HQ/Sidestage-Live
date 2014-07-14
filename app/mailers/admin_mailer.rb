class AdminMailer < ActionMailer::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  default :from => ENV["mail_from"],
          :reply_to => ENV["mail_from"],
          :return_path => ENV["mail_return_path"],
          :to => ENV["admin_recipients"] || ["schuyler@sidestage.com", "silab.kamawall@gmail.com", "daniel@sidestage.com"]

  #
  # Helpers
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  helper :application
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  def lead_notification(user)
    @user = user
    mail(subject: "Sidestage: New Lead #{user.name}") do |format|
      format.text
      format.html
    end
  end

  #
  # Protected Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  protected
  
end
