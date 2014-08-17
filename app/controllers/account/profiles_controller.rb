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
    redirect_to preview_account_profile_path(begin_of_association_chain.profiles.first) and return if begin_of_association_chain.profiles.first.present?
    new!
  end

  def create
    create! do |success, failure|
      success.html {redirect_to pricing_account_profile_path(resource) }
    end
  end
  
  def basics
    resource.wizard_step = :basics
    if request.patch?
      resource.update_attributes(permitted_params[:profile])
    end
  end
    
  def description
    resource.wizard_step = :description
    if request.patch?
      resource.update_attributes(permitted_params[:profile])
    end
  end

  def pricing
    resource.wizard_step = :pricing      
    if request.patch?
      resource.update_attributes(permitted_params[:profile])
    end    
  end 
  
  def soundcloud
    resource.wizard_step = :soundcloud
    resource.update_attributes(permitted_params[:profile])
    flash[:error] = resource.errors.full_messages.first if resource.errors.present?
    redirect_to :back
  end
  
  def youtube
    resource.wizard_step = :youtube
    resource.update_attributes(permitted_params[:profile])
    flash[:error] = resource.errors.full_messages.first if resource.errors.present? 
    redirect_to :back
  end
  
  
  def remove_soundcloud
    resource.update_attribute :soundcloud, nil
    redirect_to :back
  end

  def remove_youtube
    resource.update_attribute :youtube, nil
    redirect_to :back
  end
  
  def toggle
    resource.toggle!
    if resource.published?
      flash[:auto_modal]  = "account/profiles/share_modal"
      redirect_to artist_path(resource)
    else
      flash[:error] = t(:"flash.account.profiles.toggle.alert", edit_profile_path: basics_account_profile_path) if resource.errors.present?
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
    params.permit(profile: [:avatar, :solo, :location, :title, :name, :currency, :price, :about, :youtube, :facebook, :twitter, :soundcloud, :availability, :travel_costs, :bic, :iban, genre_ids: []])
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
