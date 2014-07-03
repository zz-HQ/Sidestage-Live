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
  
  def show
    show! do |format|
      format.html { redirect_to account_conversation_path(resource.conversation) }
    end
  end
  
  def offer
    resource.price = permitted_params[:deal][:price]
    resource.offer
    resource.save
    respond_to do |format|
      format.html { redirect_to account_conversation_path(resource.conversation) }
      format.js { render :offer }
    end
  end
  
  Deal.aasm.events.keys.each do |event|
    next if event == :offer
    define_method event do
      resource.send("#{event.to_s}!")
      flash[:notice] = t(:"flash.actions.update.deal.confirmed") if event == :accept
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
    end
  end
  
  def cannot_deal_myself
    build_resource
    redirect_to artists_path if resource.profile.nil? || resource.profile.user_id == current_user.id
  end
  
end