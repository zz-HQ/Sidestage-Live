class Message < ActiveRecord::Base

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  attr_accessor :current_user, :system_message
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  

  validates :receiver_id, :body, presence: true
  validates :sender_id, presence: true, unless: :system_message?
  validate :validate_conversation
  validate :validate_receiver

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
  scope :latest, -> { order("ID DESC") }
  scope :unread, -> { where(read_at: nil) }
  
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
    
  before_create :attach_to_conversation
  after_create :update_conversation_order, :update_receiver_counter
  
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private

  def validate_conversation
    if conversation.present?
      errors.add :conversation_id unless conversation.sender_id.in?([current_user.id, receiver_id]) || conversation.receiver_id.in?([current_user.id, receiver_id]) 
    end
  end

  def validate_receiver
    errors.add :receiver_id unless receiver.present?
  end
  
  def attach_to_conversation
    self.conversation ||= self.sender.conversations.where('receiver_id = :id OR sender_id = :id', id: self.receiver_id).first || create_conversation
  end
  
  def create_conversation
    conversation = Conversation.new
    conversation.sender_id = current_user.id
    conversation.receiver_id = current_user.id == sender_id ? sender_id : receiver_id
    conversation.body = self.body
    conversation.last_message_at = Time.now
    conversation.save
    conversation
  end
  
  def update_conversation_order
    conversation.body = self.body
    conversation.last_message_at = self.created_at
    conversation.save
  end
  
  def update_receiver_counter
    User.increment_counter :unread_message_counter, receiver_id
  end
  
end
