class Picture < ActiveRecord::Base
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  belongs_to :imageable, :polymorphic => true

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
