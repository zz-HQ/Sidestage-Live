class Picture < ActiveRecord::Base
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :imageable, :presence => true
  
  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  belongs_to :imageable, :polymorphic => true
  




  mount_uploader :picture, PictureUploader



end
