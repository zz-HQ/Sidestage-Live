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
    artist: Rails.application.secrets.mailchimp_artist_id,
    customer: Rails.application.secrets.mailchimp_customer_id,
    press: Rails.application.secrets.mailchimp_press_id
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
      chimp = Gibbon::API.new.lists.batch_subscribe(id: list_id, :double_optin => false, :batch => [{:email => {:email => email}, :merge_vars => {:FNAME => name, :LNAME => ""}}])
      if chimp["error_count"].to_i > 0 && chimp["errors"].first["code"] != 214 #ignore duplicates
        errors.add :email, chimp["errors"].first["error"]
        return false
      end
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
    SUBSCRIBER_LIST[list.to_s.to_sym] || SUBSCRIBER_LIST[:newsletter]
  end
  
end