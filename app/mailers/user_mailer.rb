class UserMailer < Devise::Mailer

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  default :from => "airmusic.co <admin@airmusic.co>",
          :reply_to => "airmusic.co <info@airmusic.co>",
          :return_path => "airmusic.co <info@airmusic.co>"
          
end