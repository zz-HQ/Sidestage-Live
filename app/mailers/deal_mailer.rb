class DealMailer < ActionMailer::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  default :from => ENV["mail_from"],
          :reply_to => ENV["mail_from"],
          :return_path => ENV["mail_return_path"]

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

  def artist_notification(deal)
    @deal = deal
    mail(setup(deal.artist, deal)) do |format|
      format.text
      format.html
    end
  end

  def customer_notification(deal)
    @deal = deal
    mail(setup(deal.customer, deal)) do |format|
      format.text
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
  
  def setup(user, deal)
    { to: user.email, subject: subject(deal) }
  end
    
  def subject(deal)
    I18n.t :"mail.deals.#{deal.state}.subject"
  end  
  
end
