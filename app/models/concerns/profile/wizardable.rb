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
      unless method_defined?("#{step}_step_valid?")
        define_method "#{step}_step_valid?" do
          errors.blank?
        end
      end
    end

    WIZARD_STEPS.each do |step|
      unless method_defined?("#{step}_step_done?")
        define_method "#{step}_step_done?" do
          wizard_state.to_s.include?(step.to_s)
        end
      end
    end

  end
  
  def step_done?(step)
    send("#{step}_step_done?")
  end

  def step_valid?(step)
    send("#{step}_step_valid?")
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
  
  def description_step_done?
    wizard_state.to_s.include?('description') || (errors.blank? && title.present? && name.present? && about.present?)
  end

  def description_step_valid?
    errors.blank? && title.present? && name.present? && about.present?
  end
  
  def concatenated_steps(step)
    wizard_state.to_s.split(",").push(step).join(",")
  end
  
  private
  
  def assign_step
    if wizard_step.present? && step_valid?(wizard_step) && !step_done?(wizard_step)
      self.wizard_state = concatenated_steps(wizard_step)
    end
  end
  
  def assign_pictures_step!(picture)
    unless step_done?(:pictures)
      self.wizard_step = :pictures
      save validation: false
    end
  end
  
end