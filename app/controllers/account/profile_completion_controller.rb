class Account::ProfileCompletionController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 

  defaults :resource_class => Profile, :singleton => true, :instance_name => 'profile'

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
      if resource.update_attributes(permitted_params[:profile])
        redirect_to description_account_profile_completion_path
      end
    end
  end
  
  def description
    resource.wizard_step = :description
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        redirect_to pricing_account_profile_completion_path
      end
    end
  end
    
  def pricing
    resource.wizard_step = :pricing      
    if request.patch?
      if resource.update_attributes(permitted_params[:profile])
        redirect_to phone_account_profile_completion_path
      end
    else
      resource.currency = Currency.pound.try(:name) if resource.london?
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
    params.permit(profile: [:avatar, :artist_type, :location, :title, :name, :price, :currency, :about, :youtube, :facebook, :twitter, :soundcloud, :availability, :travel_costs, :bic, :iban, genre_ids: []])
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