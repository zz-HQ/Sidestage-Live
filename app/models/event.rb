class Event < ActiveRecord::Base

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  attr_accessor :balanced_token, :friends_emails

  store :additionals, accessors: []

  #
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  validates :user_id, presence: true

  #
  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  belongs_to :user
  has_many :event_invitations

  #
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  before_save :make_user_paymentable

  #
  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  def user_responded?(user)
    invitation = event_invitations.where("email = ? OR attendee_id = ?", user.email, user.id).first
    invitation.present? && (invitation.accepted? || invitation.rejected?)
  end
  

  def charge_user!
    return false unless user.paymentable?
    return true if balanced_debit_id.present?
    begin
      price = 99 * 100
      
      update_columns balanced_debit_id: "SIDESTAGE_TEST", charged_price: price      
      return true
      
      debit = user.retrieve_balanced_card(user.balanced_card_id).debit(
        :amount => price,
        :appears_on_statement_as => 'Sidestage',
        :description => "#{user.name}"
      )
    update_columns balanced_debit_id: debit.id, charged_price: price
    return true
    rescue Balanced::Error => e
      user.update_column(:error_log, e.inspect) 
      errors.add :balanced_debit_id, e.extras.values.join(",")
      return false
    end
  end

  
  def invite_friends!
    if friends_emails.present?
      friends_emails.split(",").each do |email|
        event_invitations << EventInvitation.invited.new(email: email.strip, inviter: user)
      end
    end
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
  
  def make_user_paymentable
    if balanced_token.present?
      user.make_paymentable_by_token(balanced_token)
      errors.add :balanced_token, user.errors.full_messages.first if user.errors.present?
    end
  end

  
end
