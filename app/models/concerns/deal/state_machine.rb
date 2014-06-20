module Deal::StateMachine
  extend ActiveSupport::Concern


  included do
    
    #There is a better Gem 'state_machine' available, but unfortunatley not maintained anymore
    include AASM

    aasm column: 'state', whiny_transitions: false do
      
      state :requested, initial: true
      state :offered
      state :confirmed
      state :accepted
      state :declined
      state :rejected
      state :cancelled
      
      event :offer do
        transitions from: [ :requested ], to: :offered
      end
      
      event :cancel, after: :create_system_message do
        transitions from: [:requested, :offered], to: :cancelled
      end

      event :decline, after: :create_system_message do
        transitions from: [:requested, :offered], to: :declined
      end
      
      event :accept do
        transitions [:offered] => :accepted
      end
      
      event :confirm do
        transitions [ :requested ] => :confirmed
      end
      
    end

  end
  
  
end