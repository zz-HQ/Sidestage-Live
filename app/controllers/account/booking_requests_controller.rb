class Account::BookingRequestsController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 

  defaults resource_class: Deal, instance_name: 'deal'
  respond_to :html, :js

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 
  
  before_filter :cannot_book_myself
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create
    build_resource
    
    unless current_user.paymentable?
      token = params[:user] && params[:user][:stripe_token]
      if token.blank?
        flash[:error] = "Bitte Kreditkartendaten eingeben."
        render :new and return
      end
      begin
        customer = Stripe::Customer.create(card: token, description: current_user.email)
        current_user.save_stripe_customer_id!(customer.id)
      rescue Stripe::StripeError => e
        # TODO: Stripe Customer Create Error
        params[:user][:stripe_token] = nil
        flash[:error] = e.json_body[:error][:message] + ". Bitte versuchen Sie es noch einmal."
        Rails.logger.info "##########################"
        Rails.logger.info e.inspect
        Rails.logger.info "##########################"
        render :new and return
      end
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
      resource.currency = current_currency.name
      resource.profile_id ||= params[:profile_id]
    end
  end

  def cannot_book_myself
    if request.get?
      profile = Profile.where(id: params[:profile_id]).first    
      redirect_to artists_path if profile.nil? || profile.user_id == current_user.id
    end
  end
  
end
