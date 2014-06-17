class Account::ProfilesController < Account::ResourcesController

  #
  # Settings
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
  
  def index
    redirect_to new_resource_path
  end
  
  def new
    redirect_to account_profile_path(begin_of_association_chain.profiles.first) and return if begin_of_association_chain.profiles.first.present?
    new!
  end

  def create
    create! { pricing_account_profile_path(resource) }
  end
  
  def update
    update! { preview_account_profile_path(resource) }
  end
  
  def description
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        redirect_to pricing_account_profile_path(resource)
      end
    end
  end
  
  def pricing
    resource.wizard_step = :pricing      
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        redirect_to new_account_payment_detail_path
      end
    end    
  end 
  
  def complete_pricing
    resource.wizard_step = :pricing
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        redirect_to description_account_profile_path(resource)
      end
    end
  end
  
  def toggle
    resource.toggle!
    flash[:notice] = "Profile #{resource.published? ? 'published' : 'unpublished'}!"
    redirect_to account_root_path
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
    params.permit(profile: [:title, :name, :currency, :price, :about, :city, :youtube, :facebook, :twitter, :soundcloud, :late_night_fee, :night_fee, :cancellation_policy, :availability, :travel_costs, genre_ids: []])
  end 
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  
end