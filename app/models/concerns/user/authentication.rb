module User::Authentication
  extend ActiveSupport::Concern

  
  included do

    devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable
    devise :omniauthable, :omniauth_providers => [:facebook]
    
    def self.from_omniauth(auth)
      where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.remote_avatar_url = auth.info.image.gsub('http://','https://') # assuming the user model has an image
        user.skip_confirmation!
        mailchimp_api = Gibbon::API.new
        res = mailchimp_api.lists.batch_subscribe(id: Rails.application.secrets.mailchimp_newsletter_id, :double_optin => false, :batch => [{:email => {:email => user.email}, :merge_vars => {:FNAME => user.first_name, :LNAME => user.last_name}}])
      end
    end

    def self.new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

  end
  
end