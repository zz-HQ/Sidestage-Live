class EventsController < ApplicationController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 
  
  inherit_resources
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 
  
  def show
    redirect_to thanks_events_path if current_user.present? && resource.user_responded?(current_user)
  end
  
  def accept
    respond_to_invitation(true)
    redirect_to thanks_events_path
  end
  
  def reject
    respond_to_invitation(false)
    redirect_to thanks_events_path
  end
  
  def respond_to_invitation(response)
    event_invitation = resource.event_invitations.where("token = ?", session[:event_invitation_token]).first if session[:event_invitation_token].present?
    event_invitation ||= resource.event_invitations.where("email = ? OR attendee_id = ?", current_user.email, current_user.id).first
    event_invitation ||= resource.event_invitations.build(inviter_id: resource.user_id)
    if response == true
      event_invitation.accepted = true
    else
      event_invitation.rejected = true
    end
    event_invitation.email ||= current_user.email
    event_invitation.attendee_id ||= current_user.id
    event_invitation.save
    session[:event_invitation_token] = nil
  end
  
  
end