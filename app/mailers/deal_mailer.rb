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
  
  layout "email/user"
            
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
    @user = deal.artist
    @deal = deal
    mail(setup(@user, deal)) do |format|
      format.text
      format.html
    end
  end

  def customer_notification(deal)
    @user = deal.customer
    @deal = deal
    mail(setup(@user, deal)) do |format|
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
