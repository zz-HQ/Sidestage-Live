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
    redirect_to pricing_account_profile_path(resource) if resource.update_attributes(permitted_params[:profile])
  end
  
  def pricing
    resource.wizard_step = :pricing      
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        redirect_to description_account_profile_path
      end
    end    
  end 

  def description
    resource.wizard_step = :description
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        redirect_to account_profile_pictures_path(resource)
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
  
  def payment
    resource.wizard_step = :payment
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        redirect_to preview_account_profile_path(resource)
      end
    end
  end
  
  def toggle
    resource.toggle!
    if resource.published?
      redirect_to artist_path(resource)
    else
      redirect_to preview_account_profile_path(resource)
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
    params.permit(profile: [:avatar, :solo, :location, :title, :name, :currency, :price, :about, :youtube, :facebook, :twitter, :soundcloud, :cancellation_policy, :availability, :travel_costs, :bic, :iban, genre_ids: []])
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