class Admin::DashboardController < Admin::BaseController
  
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  respond_to :js, :html
  
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  def global_search
   @elastic = []
   if params[:term].present?
     @elastic = Elasticsearch::Model.multi_model_search([User], query: { match:  { _all: { query: params[:term], operator: :and } } }, size: 100) #, from: 12)
   end
   
  end
    
  # def global_search
  #  @elastic = {}
  #  if params[:term].present?
  #    @elastic = Elasticsearch::Model.multi_model_search([User], query: { match:  { _all: { query: params[:term], operator: :and } } }, size: 100).results #, from: 12)
  #  end
  #  render json: @elastic.collect { |r| { target: r.artist? ? artist_url(r.profile.slug||r.profile.id) : root_url, label: "<img class='thumb' src='#{r.avatar_mini_url}'> #{r.artist? ? "Artist" : "User"} : #{r.full_name}".html_safe, value: r.id } }
  # end
  
  
  
end
