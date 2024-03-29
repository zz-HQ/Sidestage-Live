class Message < ActiveRecord::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  include Conversationable, Measurement
  paginates_per 10
  
  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  PHONE_REGEX = /(?:[\(\)-\/\s]*\d){5,}/ #(?:\+|0|1)(?:[\(\)-\/\s]{,3}\d){5,}
  
  attr_accessor :current_user
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  

  validates :receiver_id, :sender_id, :body, presence: true
  validate :emails_not_allowed, :urls_not_allowed, :phone_numbers_not_allowed, on: :create, unless: :system_message?

  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'  
  belongs_to :conversation
  
  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  scope :by_user, ->(user_id) { where("sender_id = :user_id OR receiver_id = :user_id" , user_id: user_id) }
  scope :by_receiver, ->(user_id) { where(receiver_id: user_id) }
  scope :latest, -> { order("ID DESC") }
  scope :unread, -> { where(read_at: nil) }
  scope :non_system, -> { where("system_message IS NULL OR system_message = ?", false) }
  
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_validation :assign_sender  
  
  before_create :attach_to_conversation
  
  after_create :update_conversation_order, :update_receiver_counter, :notify_receiver

  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def read?
    read_at.present?
  end
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def assign_sender
    self.sender_id ||= current_user.try(:id)
  end

  def partner_id
    current_user.id == sender_id ? receiver_id : sender_id
  end  

  def update_conversation_order
    conversation.body = self.body
    conversation.last_message_at = self.created_at
    conversation.sender_archived = conversation.receiver_archived = false
    conversation.save
  end
  
  def update_receiver_counter
    User.increment_counter :unread_message_counter, receiver_id
  end
  
  def notify_receiver
    unless system_message?
      UserMailer.delay.message_notification(self)
    end
  end
  
  def emails_not_allowed
    errors.add :body, :invalid if body.to_s.include?("@")
  end
  
  def urls_not_allowed
    errors.add :body, :invalid if URI::extract(body.to_s, ["http", "https", "ftp"]).present? || body.to_s[/www\./]
  end
  
  def phone_numbers_not_allowed
    errors.add :body, :invalid if body.to_s[PHONE_REGEX]
  end

end
