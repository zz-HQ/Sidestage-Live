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

  def update
    resource.update_attributes(permitted_params[:user])
    render :show
  end  
  
  def complete
    if request.patch?
      if resource.update_attributes(permitted_params[:user])
        redirect_to complete_payment_account_personal_path
      end
    end    
  end
  
  def complete_payment
    if request.patch?
      if resource.update_attributes(permitted_params[:user])
        redirect_to root_path and return
      end
    end
    render :payment_details
  end
  
  def password
    if request.patch?
      if resource.update_with_password(permitted_params[:user])
        redirect_to password_account_personal_path
      end
    end
  end
  
  def payment_details
    if request.patch?
      if resource.update_attributes(permitted_params[:user])
        @credit_card = current_user.credit_card
      end
    end    
    @credit_card ||= current_user.credit_card    
  end
  
  def remove_card
    if current_user.destroy_stripe_card
      flash[:credit_card] = t("flash.actions.destroy.notice", resource_name: CreditCard.model_name.human)
    end
    redirect_to payment_details_account_personal_path
  end

  def mobile_nr
    resource.wizard_step = :mobile_nr    
    if request.patch?
      if resource.update_attributes(permitted_params[:user])
        resource.send_otp_code
        flash.now[:notice] = "Verification code sent."
      end
    end
  end
  
  def confirm_mobile_nr
    unless params[:confirmation_code] && resource.confirm_mobile_nr(params[:confirmation_code])
      flash.now[:error] = "Confirmation failed. invalid code!"
    end
    render :mobile_nr
  end
  
  def upload_avatar
    if resource.update_attributes(permitted_params[:user])
    end
    respond_to do |wants|
      wants.html {redirect_to :back}
      wants.js
    end
    
  end
  
  def destroy_avatar
    resource.remove_avatar = true
    resource.save
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
        :first_name, :last_name, :mobile_nr, :about, :password, :password_confirmation, :current_password, :stripe_token, :avatar
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
  
end