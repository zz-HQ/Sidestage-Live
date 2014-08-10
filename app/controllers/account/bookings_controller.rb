class Account::BookingsController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 

  defaults :resource_class => Deal, :collection_name => 'deals', :instance_name => 'deal'  
  actions :index
  
  respond_to :html, :js

  #
  # Filters
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
      
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def collection
    @deals ||= end_of_association_chain.my_bookings_overview.upcoming
  end

  
end