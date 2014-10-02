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
          :to => ["schuyler@sidestage.com", "daniel@sidestage.com"]
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
    mail(subject: "Sidestage: New #{user.profile.present? ? 'Artist' : 'User'}") do |format|
      format.html
    end
  end
  
  def profile_published(profile)
    @profile = profile
    mail(subject: "Sidestage: #{profile.name} published profile") do |format|
      format.html
    end
  end
  
  def booking_notification(deal)
    @deal = deal
    mail(subject: "Sidestage: Booking #{@deal.state}") do |format|
      format.html
    end
  end
  
  def more_cities(city_launch)
    @city_launch = city_launch
    mail(subject: "Sidestage: More cities signup") do |format|
      format.html
    end
  end
  
  def match_me(match_me)
    @match_me = match_me
    from = @match_me.name.present? ? "#{@match_me.name} <#{@match_me.email}>" : ENV["mail_from"]
    mail(reply_to: @match_me.email, from: from, to: "bookings@sidestage.com", subject: "Sidestage: Match Me") do |format|
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
