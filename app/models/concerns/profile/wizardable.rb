module Profile::Wizardable
  extend ActiveSupport::Concern
  
  included do
    WIZARD_STEPS = [:style, :geo, :pricing, :description, :avatar, :pictures, :music]

    WIZARD_SUB_STEPS = [:title, :about, :name]

    attr_accessor :wizard_step, :wizard_sub_step
    
    WIZARD_STEPS.each do |step|
      define_method "#{step}_step?" do
        wizard_step == step
      end
    end

    WIZARD_SUB_STEPS.each do |step|
      define_method "#{step}_sub_step?" do
        wizard_sub_step == step
      end
    end

    WIZARD_STEPS.each do |step|
      define_method "#{step}_step_done?" do
        wizard_state.to_s.include?(step.to_s)
      end
    end

  end
  
  def step_done?(step)
    send("#{step}_step_done?")
  end
  
  def wizard_complete?
    WIZARD_STEPS.map { |s| step_done?(s) }.all?
  end
  
  def remaining_wizard_steps
    WIZARD_STEPS.reject { |s| step_done?(s) }
  end

  def remaining_wizard_steps_count
    remaining_wizard_steps.size
  end
  
end