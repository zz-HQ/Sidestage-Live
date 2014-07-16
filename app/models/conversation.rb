class Conversation < ActiveRecord::Base

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :sender_id, :receiver_id, presence: true

  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'  
  
  has_many :messages, dependent: :delete_all
  has_many :deals

  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  scope :by_user, ->(user_id) { where("sender_id = :user_id OR receiver_id = :user_id" , user_id: user_id) }
  scope :ordered_by_last_message, -> { order("last_message_at DESC") }
  scope :archived_by, ->(user_id) { where("(sender_id = :user_id AND sender_archived IN (:archived)) OR (receiver_id = :user_id AND receiver_archived IN (:archived))", user_id: user_id, archived: true) }
  scope :unarchived_by, ->(user_id) { where("(sender_id = :user_id AND sender_archived IN (:archived)) OR (receiver_id = :user_id AND receiver_archived IN (:archived))", user_id: user_id, archived: [false, nil]) }
  
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def negotiator_for(user)
    self.receiver_id == user.id ? self.sender : self.receiver
  end
  
  def archived_by?(user)
    sender_id == user.id ? sender_archived? : receiver_archived?
  end
  
  def archive_by!(user)
    sender_id == user.id ? sender_archive! : receiver_archive!
  end
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private

  def sender_archive!
    update_attribute :sender_archived, true
  end

  def receiver_archive!
    update_attribute :receiver_archived, true
  end
  

end
