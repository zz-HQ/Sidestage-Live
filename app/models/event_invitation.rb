class EventInvitation < ActiveRecord::Base
  
  include Tokenable
  
  #
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  validates :event_id, :inviter_id, :email, presence: true
  validates :email, uniqueness: { scope: :event_id }
  
  #
  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  belongs_to :inviter, class_name: 'User', foreign_key: :inviter_id
  belongs_to :event, counter_cache: true
  belongs_to :attendee, class_name: 'User', foreign_key: :attendee_id
  
  #
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  after_create :mail_invitation
  after_save :send_acceptance_confirmation, :notify_host_about_acceptance

  #
  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  scope :invited, -> { where(invited: true) }  
  scope :by_invitee, -> (id) { where(invitee_id: id) }
  scope :pending, -> { where(accepted: nil, rejected: nil) }
  
  #
  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  def visited!
    update_column(:visited, true) unless visited?
  end

  def to_param
    token
  end
  
  #
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  private
  
  def send_acceptance_confirmation
    EmailWorker.perform_async(:event_acceptance_confirmation_mail, id) if accepted_changed? && accepted?
  end
  
  def notify_host_about_acceptance
    EmailWorker.perform_async(:host_event_acceptance_confirmation_mail, id) if accepted_changed? && accepted?
  end
  
  
  def mail_invitation
    EmailWorker.perform_async(:event_invitation_mail, id) if invited?
  end
    
  
end
