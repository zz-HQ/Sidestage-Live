class Account::ResourcesController < AuthenticatedController
  
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  
  inherit_resources
  
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private

  def begin_of_association_chain
    current_user
  end
    
end