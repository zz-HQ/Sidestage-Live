class Account::BookingRequestsController < AuthenticatedController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 

  defaults resource_class: Deal, instance_name: 'deal'
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create
    build_resource
    
    if current_user.stripe_customer_id.nil?
      token = params[:stripe_token]
      if token.blank?
        flash[:error] = "Bitte Kreditkartendaten eingeben."
        render :new and return
      end
      customer = Stripe::Customer.create(
        :card => token,
        :description => current_user.email
      )
      current_user.save_stripe_customer_id(customer.id)
    end

    create! do |success, failure|
      success.html { redirect_to account_conversation_path(resource.conversation) }
      failure.html { render :new }
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
    params.permit(deal: [:profile_id, :note, :start_at])
  end 
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private

  def build_resource
    super.tap do |resource|
      resource.profile_id ||= params[:profile_id]
    end
  end

  
end