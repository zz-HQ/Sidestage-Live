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
    if request.patch?
      if resource.update_attributes(permitted_params[:user])
        set_flash_message(resource)
        redirect_to payment_details_account_personal_path
      end
    end    
  end
  
  def password
    if request.patch?
      if resource.update_with_password(permitted_params[:user])
        set_flash_message(resource)
        redirect_to password_account_personal_path
      end
    end
  end
  
  def payment_details
    @credit_card = current_user.credit_card
    if request.patch?
      if resource.update_attributes(permitted_params[:user])
        @credit_card = current_user.credit_card
        set_flash_message(resource)
      end
    end    
  end
  
  def update_credit_card
    @credit_card = current_user.credit_card
    if @credit_card.update_attributes(permitted_params[:credit_card])
      set_flash_message(@credit_card)
      redirect_to payment_details_account_personal_path and return
    end
    render :payment_details
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
    params.permit user: [
        :first_name, :last_name, :about, :password, :password_confirmation, :current_password, :stripe_token, :avatar
      ],
      credit_card: [
        :name, :exp_month, :exp_year
      ]
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
  
  def set_flash_message(res)
    flash[:notice] = t("flash.actions.update.notice", resource_name: res.class.model_name.human)
  end
  
end