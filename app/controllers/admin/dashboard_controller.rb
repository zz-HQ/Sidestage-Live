class Admin::DashboardController < Admin::BaseController
  
  
  def global_search
    elastic = Elasticsearch::Model.search params[:q], [User, Profile]
    render json: elastic.results.to_json
  end
  
  
end