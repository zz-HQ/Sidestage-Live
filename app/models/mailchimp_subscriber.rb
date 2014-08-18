class MailchimpSubscriber    
  include ActiveModel::Model, ActiveModel::Validations

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  attr_accessor :email, :name, :list
  SUBSCRIBER_LIST = {
    newsletter: Rails.application.secrets.mailchimp_newsletter_id,
    general: Rails.application.secrets.mailchimp_list_id,
    artist: Rails.application.secrets.mailchimp_artist_id,
    customer: Rails.application.secrets.mailchimp_customer_id
  }
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validate :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  
  def save
    if valid?
      Gibbon::API.new.lists.batch_subscribe(id: list_id, :double_optin => false, :batch => [{:email => {:email => email}, :merge_vars => {:FNAME => name, :LNAME => ""}}])
    else
      return false
    end
  end

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  private
  
  def list_id
    SUBSCRIBER_LIST[list] || SUBSCRIBER_LIST[:general]
  end
  
end