class DealMailer < ActionMailer::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  
  include ActionView::Helpers::SanitizeHelper 
  
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
  
  after_filter :send_sms
            
  #
  # Helpers
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #

  def artist_notification(deal)
    @user = deal.artist
    @deal = deal

    setup_notification_body(deal.customer, deal)
    mail(setup(@user, deal)) do |format|
      format.text
      format.html
    end
  end

  def customer_notification(deal)
    @user = deal.customer
    @deal = deal

    setup_notification_body(deal.artist, deal)    
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
  
  def setup_notification_body(partner, deal)
    @notification_body ||= t("mail.deals.#{deal.state}.body_html",
      partner_name: partner.profile_name,
      deal_path: account_conversation_url(deal.conversation),
      event_date: l(deal.start_at.to_date, format: :event_date))
  end
  
  def send_sms
    @user.send_sms(strip_tags(@notification_body))
  end
  
end
