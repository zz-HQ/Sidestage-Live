class Account::DealsController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 
  
  actions :all, :except => [:create, :new]
  respond_to :html, :js
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def accept
    if resource.is_customer?(current_user)
      if resource.accept!
        flash[:notice] = "accepted!"
      else
        flash[:error] = resource.errors.full_messages.join("<br/>")
      end
    end
    redirect_to account_conversation_path(resource.conversation)
  end
  
  def confirm
    if resource.is_artist?(current_user)
      if resource.confirm!
        flash[:notice] = "Confirmed!"
      else
        flash[:error] = resource.errors.full_messages.join("<br/>")
      end
    end
    redirect_to account_conversation_path(resource.conversation)        
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
    params.permit(deal: [:start_at])
  end
    
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private

  
end