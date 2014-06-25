class Account::ReviewsController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  actions :create, :new

  belongs_to :profile

  respond_to :html, :js  

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create
    create! do |format|
      format.html{
        redirect_to root_path 
      }
      format.js{
        Rails.logger.info "###########################"
        Rails.logger.info "sf"
        Rails.logger.info "###########################"
      }
    end
    
  end

  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  protected
  
  def permitted_params
    params.permit(review: [:body, :profile_id, :rate])
  end  

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def parent
    Profile.published.where(id: params[:profile_id]).first
  end
  
  def end_of_association_chain
    parent.reviews
  end
  
  def build_resource
    super.tap do |review|
      review.author_id = current_user.id
    end
  end
  
end