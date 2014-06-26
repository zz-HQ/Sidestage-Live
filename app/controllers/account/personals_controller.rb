class Account::PersonalsController < Account::ResourcesController
  
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  

  defaults :resource_class => User, :singleton => true, :instance_name => 'user'
  
  actions :show, :update
  
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def complete
    update_account(payment_account_personal_path)
  end
  
  def password
    if request.patch?
      if resource.update_with_password(permitted_params[:user])
        flash[:notice] = t("flash.actions.update.notice", resource_name: resource.class.model_name.human) 
        redirect_to password_account_personal_path
      end
    end
  end
  
  def payment
    update_account(payment_account_personal_path)
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
    params.permit(user: [:first_name, :last_name, :about, :password, :password_confirmation, :current_password, :stripe_token, :avatar])
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
    get_resource_ivar || set_resource_ivar(current_user)
  end

  def update_account(redirect_path)
    if request.patch?
      if resource.update_attributes(permitted_params[:user])
        flash[:notice] = t("flash.actions.update.notice", resource_name: resource.class.model_name.human) 
        redirect_to redirect_path
      end
    end
  end
  
end