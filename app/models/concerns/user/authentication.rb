module User::Authentication
  extend ActiveSupport::Concern

  
  included do
    
    attr_accessor :new_fb_signup

    devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable
    devise :omniauthable, :omniauth_providers => [:facebook]
    
    def self.from_omniauth(auth)
      where(provider: auth[:provider], uid: auth[:uid]).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.full_name = [auth.info.first_name, auth.info.last_name].compact.join(" ")
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