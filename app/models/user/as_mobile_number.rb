class User::AsMobileNumber < User
  
  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  attr_accessor :mobile_confirmation_code
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :mobile_nr, presence: true
  validates :mobile_nr, format: { with: /\A\+[1-9][0-9]+\z/ }, allow_blank: true

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_validation :sanitize_mobile_nr
  
  before_save :verify_mobile_confirmation_code
  
  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def reset_mobile_nr!
    update_columns(mobile_nr: nil, mobile_nr_confirmed_at: nil)
  end  

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def sanitize_mobile_nr
    self.mobile_nr = mobile_nr.to_s.gsub(/\s/,'') if mobile_nr_changed? 
  end

  def verify_mobile_confirmation_code
    if mobile_confirmation_code.present?
      errors.add :mobile_confirmation_code, :invalid if confirm_mobile_nr(mobile_confirmation_code) == false
    end
  end
  
end