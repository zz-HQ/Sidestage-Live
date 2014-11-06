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
  
  def basics
    resource.wizard_step = :basics
    if request.patch?
      resource.update_attributes(permitted_params[:profile])
    end
  end
  
  def avatar
    unless request.get?
      resource.update_attributes(permitted_params[:profile])
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
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
    flash[:error] = resource.errors.messages[:soundcloud].try(:first) if resource.errors.present? 
    redirect_to :back
  end
  
  def youtube
    resource.wizard_step = :youtube
    resource.update_attributes(permitted_params[:profile])
    flash[:error] = resource.errors.messages[:youtube].try(:first) if resource.errors.present? 
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
    params.permit(profile: [:avatar, :artist_type, :currency, :location, :latitude, :longitude, :country_short, :country_long, :title, :name, :price, :about, :youtube, :facebook, :twitter, :soundcloud, :availability, :travel_costs, :bic, :iban, genre_ids: []])
  end 
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def resource
    get_resource_ivar || set_resource_ivar(current_user.profile)
  end  
  
end
