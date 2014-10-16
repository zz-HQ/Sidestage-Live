class ForwardController < ApplicationController

  def event_invitation
    event_invitation = EventInvitation.where(token: params[:token]).first
    redirect_to root_path and return if event_invitation.nil?
    event_invitation.visited!
    session[:event_invitation_token] = event_invitation.token
    redirect_to event_path(event_invitation.event)
  end
  
  def facebook_auth
    params[:return_to] = request.referrer
    store_location
    redirect_to user_omniauth_authorize_path(:facebook)  
  end
  
end