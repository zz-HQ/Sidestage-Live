class PagesController < ApplicationController

	def city
	end

  def share_profile_by_email
    @profile = Profile.find_by_slug(params[:slug])
    @coupon = @profile.share_with_friend_coupon
    render layout: false
  end
end
