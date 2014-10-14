class Account::HostEventsController < Account::ResourcesController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  defaults resource_class: Event, instance_name: 'event', collection_name: 'events'
  
  
end