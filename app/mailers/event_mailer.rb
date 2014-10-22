class EventMailer < ActionMailer::Base

  helper Account::EventsHelper

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
  
  #
  # Helpers
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  
  

  def confirmation_notification(event)
    @event = event

    mail(to: @event.user.email, subject: "Sidestage Event Confirmation") do |format|
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
