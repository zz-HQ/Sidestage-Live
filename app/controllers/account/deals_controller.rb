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
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  Deal.aasm.events.keys.each do |event|
    define_method event do
      resource.send("#{event.to_s}!")
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
    params.permit(deal: [:start_at, :profile_id])
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
    super.tap do |deal|
      deal.customer_id = current_user.id
      deal.current_user = current_user
    end
  end
  
  
end