class Account::DealsController < AuthenticatedController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 
  
  actions :all, :except => [:create, :new]
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def accept
    if resource.is_customer?(current_user)
      resource.accept!
      flash[:notice] = "accepted!"
    end
    redirect_to account_conversation_path(resource.conversation)
  end
  
  def confirm
    if resource.is_artist?(current_user)
      resource.confirm!
      flash[:notice] = "confirmed!"
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
  
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private

  
end