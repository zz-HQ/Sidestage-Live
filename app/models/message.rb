class Message < ActiveRecord::Base

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :sender_id, :receiver_id, :subject, :body, presence: true
  validate :validate_receiver #, :validate_thread

  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'  
  belongs_to :thread, class_name: 'Message'  
  belongs_to :replies, class_name: 'Message', foreign_key: :thread_id  

  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  scope :by_user, ->(user_id) { where("sender_id = :user_id OR receiver_id = :user_id" , user_id: user_id) }
  


  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def validate_receiver
    errors.add :receiver_id unless receiver.present?
  end
  
  def validate_thread
    if thread_id.present?
      errors.add :thread_id unless sender.messages.where(id: thread_id, thread_id: nil).present?
    end
  end
  
end
