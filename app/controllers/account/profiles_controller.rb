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
  
  def complete
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        redirect_to pricing_account_profile_path(resource)
      end
    end
  end
  
  def pricing
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        redirect_to new_account_payment_detail_path
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
    params.permit(profile: [:tagline, :currency, :price, :description, :about, :city, :youtube, :style, :soundcloud, :late_night_fee, :night_fee, :cancellation_policy, :availability, :travel_costs, genre_ids: []])
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