class Event < ActiveRecord::Base

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  BLACK_PRICE = 99

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
  belongs_to :coupon
  has_many :event_invitations

  #
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  before_save :assign_coupon

  #
  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  def self.black_currency
    Currency.dollar
  end

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
    return false if balanced_token.blank?
    return true if balanced_debit_id.present?
    begin
      price = (coupon_price || BLACK_PRICE) * 100      
      # update_columns balanced_debit_id: "SIDESTAGE_TEST", charged_price: price      
      # return true
      debit = Balanced::Card.fetch("/cards/#{balanced_token}").debit(
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
  
  def notify_sidestage!
    AdminMailer.delay.event_notification(self)
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
  
  def assign_coupon
    if coupon_id_changed? && coupon.present?
      self.coupon_code = coupon.code
      self.coupon_price = coupon.event_price
    end
  end  

  
end
