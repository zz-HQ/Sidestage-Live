class AdminMailer < ActionMailer::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  default :from => ENV["mail_from"],
          :reply_to => ENV["mail_from"],
          :return_path => ENV["mail_return_path"],
          :to => ["schuyler@sidestage.com", "silab.kamawall@gmail.com", "daniel@sidestage.com"]
  #
  # Helpers
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  helper :application
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  def lead_notification(user)
    @user = user
    mail(subject: "Sidestage: New #{user.profile.present? ? 'Profile' : 'User'} Lead") do |format|
      format.html
    end
  end
  
  def profile_published(profile)
    @profile = profile
    mail(subject: "Sidestage: #{profile.name} published profile") do |format|
      format.html
    end
  end
  
  def new_booking_request(deal)
    @deal = deal
    mail(subject: "Sidestage: new booking request") do |format|
      format.html
    end
  end
  
  def more_cities(city_launch)
    @city_launch = city_launch
    mail(subject: "Sidestage: More cities signup") do |format|
      format.html
    end
  end
  
  #
  # Protected Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  protected
  
end
