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
  validates :mobile_nr, format: { with: /\A\+[1-9][0-9]+\z/ }, length: { minimum: 8 }, allow_blank: true
  validate :must_include_country_code, :must_start_with_non_zero, :must_start_with_plus
  
  
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
  
  def must_start_with_non_zero
    if mobile_nr.to_s.starts_with?("+0")
      errors.delete :mobile_nr
      errors.add :mobile_nr, :must_start_with_non_zero
    end
  end
  
  def must_start_with_plus
    unless mobile_nr.to_s.starts_with?("+")
      errors.delete :mobile_nr
      errors.add :mobile_nr, :plus_missing
    end
  end
  
  def must_include_country_code
    unless mobile_nr.to_s =~ /\A\+[1-9].*\z/
      errors.delete :mobile_nr
      errors.add :mobile_nr, :country_code_missing
    end
  end

  def verify_mobile_confirmation_code
    if mobile_confirmation_code.present?
      errors.add :mobile_confirmation_code, :invalid if confirm_mobile_nr(mobile_confirmation_code) == false
    end
  end
  
end