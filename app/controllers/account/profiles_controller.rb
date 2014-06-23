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
    create! do |success, failure|
      success.html {redirect_to pricing_account_profile_path(resource) }
    end
  end
  
  def update
    update! { preview_account_profile_path(resource) }
  end
  
  def description
    resource.wizard_step = :description
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        set_flash
        redirect_to payment_account_profile_path(resource)
      end
    end
  end
  
  def pricing
    resource.wizard_step = :pricing      
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        set_flash        
        redirect_to pricing_account_profile_path
      end
    end    
  end 
  
  def complete_pricing
    resource.wizard_step = :pricing
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        set_flash
        redirect_to description_account_profile_path(resource)
      end
    end
  end
  
  def toggle
    resource.toggle!
    set_flash
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
    params.permit(profile: [:solo, :location, :title, :name, :currency, :price, :about, :youtube, :facebook, :twitter, :soundcloud, :cancellation_policy, :availability, :travel_costs, genre_ids: []])
  end 
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def set_flash
    flash[:notice] = t("flash.actions.update.notice", resource_name: resource.class.model_name.human) 
  end
  
  
end