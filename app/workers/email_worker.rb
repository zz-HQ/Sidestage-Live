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
  
end