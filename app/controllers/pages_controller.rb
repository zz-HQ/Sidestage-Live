class PagesController < ApplicationController

	def city
	end

  def share_profile_by_email
    @profile = Profile.find_by_name(params[:name])
    render layout: false
  end
end
