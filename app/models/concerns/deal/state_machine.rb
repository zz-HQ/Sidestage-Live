module Deal::StateMachine
  extend ActiveSupport::Concern


  included do

    include AASM

    aasm column: 'state' do
      
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
        transitions [:requested] => :declined
      end
      
      event :accept do
        transitions [:offered] => :accepted
      end
      
      event :cancel do
        transitions [:requested, :offered] => :cancelled
      end

    end

  end
  
end