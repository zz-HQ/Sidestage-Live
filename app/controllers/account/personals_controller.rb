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
    if resource.errors.blank? && (resource.email != permitted_params[:user][:email])
      flash.now[:notice] = t(:"flash.account.users.update.email.notice")
    end
    render :show
  end  
  
  def complete
    if request.patch?
      if resource.avatar.present?
        redirect_to complete_payment_account_personal_path
      else
        flash.now[:error] = t(:"flash.account.users.complete.alert")
      end
    end    
  end
  
  def complete_payment
    if request.patch?
      if resource.update_attributes(permitted_params[:user])
        redirect_to root_path, notice: t(:"flash.account.users.complete_payment.notice", mobile_nr_path: account_mobile_numbers_path)
      end
    end
  end
  
  def skip_payment
    redirect_to root_path, notice: t(:"flash.account.users.skip_payment.notice", payment_path: complete_payment_account_personal_path)
  end
  
  def password
    if request.patch?
      if resource.update_with_password(permitted_params[:user])
        sign_in resource, bypass: true
        flash.now[:notice] = t("flash.actions.update.password.notice")
        render :password
      end
    end
  end
  
  def payment_details
    if request.patch?
      if resource.update_attributes(permitted_params[:user])
        @credit_card = resource.credit_card
      end
    end
    if resource.errors.present?
      flash.now[:error] = resource.errors.full_messages.first
    end
    @credit_card ||= current_user.credit_card    
  end

  def remove_card
    current_user.destroy_balanced_card
    redirect_to payment_details_account_personal_path
  end
  
  def bank_details
    if request.patch?
      resource.profile.update_attributes(permitted_params[:profile])
    end
  end
  
  def remove_bank_account
    current_user.profile.destroy_balanced_bank_account!
    redirect_to bank_details_account_personal_path
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
        :email, :full_name, :mobile_nr, :about, :password, :password_confirmation, :current_password, :balanced_token, :avatar
      ],
      credit_card: [ :name, :exp_month, :exp_year ],
      profile: [:balanced_token, :iban, :bic, :routing_number, :account_number, :payout_name, :payout_state, :payout_city, :payout_postal_code, :payout_street, :payout_street_2, :payout_country]
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