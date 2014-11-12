class EmailWorker
  include Sidekiq::Worker
  
  def perform(method, id)
    send(method, id)
  end

  
  def event_invitation_mail(event_invitation_id)
    event_invitation = EventInvitation.where(id: event_invitation_id).first
    return if event_invitation.nil?
    EventInvitationMailer.invite(event_invitation).deliver
  end

  def event_acceptance_confirmation_mail(event_invitation_id)
    event_invitation = EventInvitation.where(id: event_invitation_id).first
    return if event_invitation.nil?
    EventInvitationMailer.acceptance_confirmation(event_invitation).deliver
  end

  def host_event_acceptance_confirmation_mail(event_invitation_id)
    event_invitation = EventInvitation.where(id: event_invitation_id).first
    return if event_invitation.nil?
    EventInvitationMailer.host_acceptance_confirmation(event_invitation).deliver
  end
  
  def profile_published_confirmation(profile_id)
    profile = Profile.where(id: profile_id).first
    UserMailer.profile_published_confirmation(profile).deliver
  end

  def welcome_artist(profile_id)
    profile = Profile.where(id: profile_id).first
    UserMailer.welcome_artist(profile).deliver
  end


end