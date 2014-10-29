class EventInvitationMailer < ActionMailer::Base

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
  
  layout "email/event_invitation"

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
  
  

  def invite(event_invitation)
    @event_invitation = event_invitation

    mail(to: @event_invitation.email, subject: "Sidestage Event Invitation") do |format|
      format.text
      format.html
    end
  end
  
  def acceptance_confirmation(event_invitation)
    @event_invitation = event_invitation

    mail(to: @event_invitation.attendee.try(:email) || @event_invitation.email, subject: "Sidestage Event Confirmation") do |format|
      format.text
      format.html
    end    
  end

  def host_acceptance_confirmation(event_invitation)
    @event_invitation = event_invitation

    mail(to: @event_invitation.inviter.email, subject: "Sidestage Event Confirmation") do |format|
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
