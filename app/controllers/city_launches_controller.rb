class CityLaunchesController < ApplicationController  

  inherit_resources

  def create
    create!(notice: "Thanks!"){ root_path }
  end

  def permitted_params
    params.permit(city_launch: [:email, :city])
  end 

  
end
