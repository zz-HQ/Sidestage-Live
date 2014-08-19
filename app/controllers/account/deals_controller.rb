class Account::DealsController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 
  
  respond_to :html, :js

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 
  
  before_filter :cannot_deal_myself, only: [:new, :create]
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create
    create! do |success, failure|
      success.html{ 
        redirect_to account_conversation_path(resource.conversation), notice: t(:"flash.account.deals.create.notice") 
      }
      success.js{
        flash[:notice] = t(:"flash.account.deals.create.notice")
      }
    end
  end
  
  def offer
    resource.price = permitted_params[:deal][:price]
    resource.offer
    if resource.save
      flash[:notice] = t(:"flash.account.deals.offer.notice")    
    end
    respond_to do |format|
      format.html { redirect_to account_conversation_path(resource.conversation) }
      format.js
    end
  end
  
  def confirm
    resource.confirm!
    respond_to do |format|
      format.html{
        if resource.errors.include?(:customer_id)
          flash[:error] = resource.errors.messages[:customer_id].first
          redirect_to payment_details_account_personal_path
        else
          flash[:notice] = t(:"flash.account.deals.confirm.notice")
          redirect_to account_conversation_path(resource.conversation)
        end
      }
    end
  end
  
  Deal.aasm.events.keys.reject { |e| e.in?([:offer, :confirm]) }.each do |event|
    define_method event do
      resource.send("#{event.to_s}!")
      flash[:notice] = t(:"flash.account.deals.#{action_name}.notice")
      respond_to do |format|
        format.html { redirect_to account_conversation_path(resource.conversation) }
        format.js { render :show }
      end
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
    params.permit(deal: [:start_at, :price, :profile_id, :stripe_token])
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
    super.tap do |contact|
      contact.current_user = current_user
    end
  end  

  def build_resource
    super.tap do |deal|
      deal.current_user = current_user
      deal.customer = current_user
    end
  end
  
  def cannot_deal_myself
    build_resource
    redirect_to artists_path if resource.profile.nil? || resource.profile.user_id == current_user.id
  end
  
end