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
  
  validates :mobile_nr, :mobile_nr_country_code, presence: true
  validates :mobile_nr, length: { minimum: 5 }, allow_blank: true
  validates :mobile_nr, numericality: true, allow_blank: true
  validate :must_start_with_non_zero, :should_not_start_with_plus
  
  
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #before_validation :sanitize_mobile_nr
  
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

  def must_start_with_non_zero
    if mobile_nr.to_s.starts_with?("0")
      errors.delete :mobile_nr
      errors.add :mobile_nr, :must_start_with_non_zero
    end
  end
  
  def should_not_start_with_plus
    if mobile_nr.to_s.starts_with?("+") || mobile_nr.to_s.starts_with?("-")
      errors.delete :mobile_nr
      errors.add :mobile_nr, :invalid
    end
  end

  def verify_mobile_confirmation_code
    if mobile_confirmation_code.present?
      errors.add :mobile_confirmation_code, :invalid if confirm_mobile_nr(mobile_confirmation_code) == false
    end
  end
  
end
