module Deal::StateMachine
  extend ActiveSupport::Concern


  included do

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
        transitions [:requested] => :offered
      end
      
      event :confirm do
        transitions [:requested] => :confirmed
      end
      
      event :decline do
        transitions from: [:requested, :offered], to: :declined
      end
      
      event :accept do
        transitions [:offered] => :accepted
      end
      
      event :cancel do
        transitions from: [:requested, :offered], to: :cancelled
      end

    end

  end
  
end