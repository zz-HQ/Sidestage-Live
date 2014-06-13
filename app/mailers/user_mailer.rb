class UserMailer < Devise::Mailer

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  default :from => "sidestage.com <admin@sidestage.com>",
          :reply_to => "sidestage.com <info@sidestage.com>",
          :return_path => "sidestage.com <info@sidestage.com>"
          
end
