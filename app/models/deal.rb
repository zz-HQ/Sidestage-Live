class Deal < ActiveRecord::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  include Deal::StateMachine, Conversationable, BalancedPayment, Surcharge
  
  #has_paper_trail only: [ :state ], on: [:update, :destroy], class_name: "Versions::#{self.name}"
  
  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  attr_accessor :current_user, :balanced_token

  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :artist_id, :profile_id, :customer_id, :price, :start_at, :currency, :conversation_id, presence: true
  validates :price, numericality: { greater_than: 24 }, allow_blank: true 
  
  validate :customer_must_be_chargeable, if: :should_customer_be_chargeable?

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_validation :assign_artist, :assign_customer, :set_price, :set_currency, :attach_to_conversation, :make_customer_paymentable, on: :create
  
  before_save :set_state_transition_at
  
  after_save :create_system_message
  
  after_create :create_user_message, :notify_admin
  
  after_rollback :ensure_balanced_charge!, on: :update
  
  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  belongs_to :profile
  belongs_to :artist, foreign_key: :artist_id, class_name: 'User'
  belongs_to :customer, foreign_key: :customer_id, class_name: 'User'

  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  scope :by_user, ->(user_id) { where('artist_id = :user_id OR customer_id = :user_id', user_id: user_id) }
  scope :by_profile, ->(profile_id) { where(profile_id: profile_id) }
  scope :pending, -> { where(state: Deal::PENDING_STATES) }
  scope :dealed, -> { where(state: Deal::CONFIRMED_STATES) }
  scope :upcoming, -> { order("deals.start_at ASC") }
  scope :past, -> { where("DATE(deals.start_at) < ?", Time.now) }
  scope :future, -> { where("deals.start_at > ?", Time.now) }
  scope :latest, -> { order("deals.id DESC") }
  scope :visible_in_conversation, -> { future.where('state IN (?)', Deal::VISIBLE_CONVERSATION_STATES) }
  scope :since, ->(since) { where("updated_at > ?", since) }
  scope :created_since, ->(since) { where("created_at > ?", since) }
  scope :my_bookings_overview, -> { where(state: [:confirmed, :accepted]) }
  scope :undealed, -> { where(state: Deal::UNDEALED_STATES)}   
  scope :paid_out, -> { where('paid_out = ? OR balanced_credit_id IS NOT NULL', true) }
  scope :balanced_paid_out, -> { where('balanced_credit_id IS NOT NULL') }  
  scope :not_paid_out, -> { where('paid_out IS NULL OR paid_out = ? OR balanced_credit_id IS NULL', false) }
  scope :charged, -> { where('balanced_debit_id IS NOT NULL') }
   
  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def is_customer?(user)
    customer_id == user.id
  end

  def is_artist?(user)
    artist_id == user.id
  end
  
  def partner_id
    current_user.id == artist_id ? customer_id : artist_id
  end 
  
  def negotiator_for(user)
    @negotiator ||= is_customer?(user) ? artist : customer
  end
  
  def balanced_paid_out?
    balanced_credit_id.present?
  end
  
  def paid_out?
    super || balanced_paid_out?
  end

  def credit_on_the_way
    artist.send_sms(I18n.t(:"view.messages.credit_on_the_way"))
  end
   
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  #
  # Initialization
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  def assign_artist
    self.artist_id ||= profile.try(:user_id)
  end
  
  def assign_customer
    self.customer_id ||= current_user.id
  end
  
  def set_price
    self.price ||= profile.try(:price)
  end

  def set_currency
    self.currency ||= profile.try(:currency)
  end
  
  def set_state_transition_at
    self.state_transition_at = Time.now if changes.include?('state')
  end

  
  #
  # Custom Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def customer_must_be_chargeable
    errors.add :customer_id, :not_chargeable unless customer.paymentable?
    customer.paymentable?
  end
  
  #
  # Background
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create_system_message
    if changes.include?('price') || changes.include?('state')
      message = Message.new current_user: current_user, receiver_id: partner_id, conversation_id: conversation_id, system_message: true
      message.body = { 
        source: self.class.name, 
        source_id: self.id, 
        state: state, 
        current_user_id: current_user.id, 
        customer_id: customer_id, 
        artist_id: artist_id,
        price: price_with_surcharge,
        event_date: start_at }.to_json
      if message.save
        notify_partner_via_email
        notify_partner_via_sms
      end
    end
  end
  
  def create_user_message
    if body.present?
      message = Message.new body: body, current_user: current_user, receiver_id: partner_id, conversation_id: conversation_id
      message.save
    end
  end
  
  def make_customer_paymentable
    if balanced_token.present?
      customer.make_paymentable_by_token(balanced_token)
      errors.add :balanced_token, customer.errors.full_messages.first if customer.errors.present?
    end
  end
  
  def notify_partner_via_email
    if state.to_sym.in?(NOTIFY_BOTH_PARTIES_STATES)
      DealMailer.delay.artist_notification(self)
      DealMailer.delay.customer_notification(self)
    elsif is_customer?(current_user)
      DealMailer.delay.artist_notification(self)
    else
      DealMailer.delay.customer_notification(self)
    end
  end
  
  def notify_partner_via_sms
    if state.to_sym.in?(SMS_NOTIFY_BOTH_PARTIES_STATES)
      send_sms_to_partner(from: customer, to: artist)
      send_sms_to_partner(from: artist, to: customer)
    elsif is_customer?(current_user)
      send_sms_to_partner(from: customer, to: artist)
    else
      send_sms_to_partner(from: artist, to: customer)
    end
  end
  
  def send_sms_to_partner(from:, to:)
    notification_body = I18n.t("mail.deals.#{state}.body_html", partner_name: from.profile_name,  deal_path: "", event_date: I18n.l(start_at.to_date, format: :event_date))
    to.send(:send_sms, ActionController::Base.helpers.strip_tags(notification_body))
  end
  
  def ensure_balanced_charge!
    if changes.include?(:balanced_debit_id) && balanced_debit_id.present?
      update_columns(charged_price: price_with_surcharge_in_cents, balanced_debit_id: balanced_debit_id)
    end
  end
  
  def should_customer_be_chargeable?
    requested? || confirmed?    
  end
  
  def notify_admin
    AdminMailer.delay.booking_notification(self)
  end
  
end
