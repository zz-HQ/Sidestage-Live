module User::Authentication
  extend ActiveSupport::Concern

  
  included do
    
    attr_accessor :new_fb_signup

    devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable
    devise :omniauthable, :omniauth_providers => [:facebook]
    
    def self.from_omniauth(auth)
      Rails.logger.info "##########################"
      Rails.logger.info auth.raw_info.inspect
      Rails.logger.info "##########################"

      where(provider: auth[:provider], uid: auth[:uid]).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.full_name = [auth.info.first_name, auth.info.last_name].compact.join(" ")

        user.birthday =  auth.extra.raw_info.birthday
        user.fb_first_name = auth.extra.raw_info.first_name
        user.fb_last_name = auth.extra.raw_info.last_name
        user.fb_link = auth.extra.raw_info.link
        user.fb_locale = auth.extra.raw_info.locale
        user.fb_timezone = auth.extra.raw_info.timezone

        user.remote_avatar_url = auth.info.image.gsub('http://','https://') # assuming the user model has an image
        user.skip_confirmation!
        user.new_fb_signup = true if user.new_record?
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