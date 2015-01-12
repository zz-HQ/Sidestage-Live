class UserMailer < Devise::Mailer

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  default :from => ENV["mail_from"],
          :reply_to => ENV["mail_from"],
          :return_path => ENV["mail_return_path"]
  
  layout "email/user"

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  after_filter :send_sms, only: [:message_notification]
    
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  def message_notification(message)
    @user = message.receiver
    @message = message
    mail(to: @user.email, subject: "New Message") do |format|
      format.text
      format.html
    end
  end
  
  def profile_published_confirmation(profile)
    @profile = profile
    mail(to: @profile.user.email, from: "daniel@sidestage.com", reply_to: "daniel@sidestage.com", subject: "Your profile is published") do |format|
      format.text
      format.html
    end
  end
  
  def share_profile_with_friend(profile, friends_email)
    @profile = profile
    @coupon = @profile.share_with_friend_coupon
    @currency = Currency.by_name(@coupon.currency) if @coupon.present?
    mail(to: friends_email, from: "invite@sidestage.com", subject: "#{@profile.name} is now on Sidestage") do |format|
      format.text
      format.html
    end
  end
  
  def send_sms
    @user.send_sms(t(:"view.messages.sms", partner_name: @message.sender.profile_name))
  end
  
end