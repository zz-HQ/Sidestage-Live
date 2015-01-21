class PagesController < ApplicationController

	def city
	end

  def share_profile_by_email
    @profile = Profile.find_by_name(params[:name])
    @coupon = @profile.share_with_friend_coupon
    render layout: false
  end
end
