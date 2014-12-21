class Picture < ActiveRecord::Base
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  validates :picture, presence: true
  
  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  belongs_to :imageable, :polymorphic => true
  acts_as_list scope: :imageable

  mount_uploader :picture, PictureUploader
  
  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  scope :latest, -> { order("pictures.id DESC") }
  
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 

end
