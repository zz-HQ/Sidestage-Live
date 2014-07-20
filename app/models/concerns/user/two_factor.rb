module User::TwoFactor
  extend ActiveSupport::Concern

  
  included do    

    def self.allowed_otp_drift_seconds
      300
    end

  end

  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def mobile_nr_confirmed?
    mobile_nr_confirmed_at.present?
  end

  def send_otp_code
    SmsWorker.perform_async(id, confirmation_body)
    Rails.logger.info "####### #{confirmation_body} ###################" if Rails.env.development?
  end
  
  def otp_code(time = Time.now)
    @otp_code ||= ROTP::TOTP.new(otp_secret_key.to_s, drift: User.allowed_otp_drift_seconds).at(time, true)
  end
  
  def confirm_mobile_nr(code)
    return true if mobile_nr_confirmed_at.present?
    return update_attribute(:mobile_nr_confirmed_at, Time.now) if verify_otp(code)
    return false
  end
  
  def verify_otp(code)
    totp = ROTP::TOTP.new(otp_secret_key.to_s, drift: User.allowed_otp_drift_seconds)
    totp.verify_with_drift(code, User.allowed_otp_drift_seconds)
  end
  
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
    
  private 
  
  def confirmation_body
    "Sidestage confirmation code: #{otp_code}"
  end  
  
end