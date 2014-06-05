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
    create! do |success, failure|
      success.html { redirect_to account_conversation_path(resource.conversation) }
      failure.html { render :new }
    end
    
    # Get the credit card details submitted by the form
    # token = params[:stripeToken]
    # 
    # # Create a Customer
    # customer = Stripe::Customer.create(
    #   :card => token,
    #   :description => "payinguser@example.com"
    # )

    # Charge the Customer instead of the card
    # Stripe::Charge.create(
    #     :amount => 1000, # in cents
    #     :currency => "eur",
    #     :customer => customer.id
    # )

    # Save the customer ID in your database so you can use it later
    # save_stripe_customer_id(user, customer.id)

    # Later...
    # customer_id = get_stripe_customer_id(user)

    # Stripe::Charge.create(
    #  :amount   => 1500, # €15.00 this time
    #  :currency => "eur",
    #  :customer => customer_id
    # )    
    
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