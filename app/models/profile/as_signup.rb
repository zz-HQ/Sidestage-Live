class Profile::AsSignup < Profile
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  validates :user_id, :genre_ids, :location, presence: true

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_save :assign_steps_on_signup, on: :create
  
  
  
  
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def assign_steps_on_signup
    self.wizard_state = concatenated_steps(:style) + concatenated_steps(:geo)
  end

end