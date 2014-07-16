class CityLaunch < ActiveRecord::Base
  validates :email, :city, presence: true
end
