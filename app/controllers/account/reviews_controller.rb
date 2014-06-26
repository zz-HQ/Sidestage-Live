class Account::ReviewsController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  actions :create, :new

  belongs_to :profile, class_name: Profile, finder: :find_reviewable

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
  
  def begin_of_association_chain
  end
  
  def build_resource
    super.tap do |review|
      review.author_id = current_user.id
    end
  end
  
end