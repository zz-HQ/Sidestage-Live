module Profile::Wizardable
  extend ActiveSupport::Concern
  
  included do
    WIZARD_STEPS = [:style, :geo, :pricing, :description, :avatar, :pictures, :music]

    WIZARD_SUB_STEPS = [:title, :about, :name, :soundcloud, :youtube]

    attr_accessor :wizard_step, :wizard_sub_step

  
    before_save :assign_step
    
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
      unless method_defined?("#{step}_step_persisted?")
        define_method "#{step}_step_persisted?" do
          wizard_state.to_s.include?(step.to_s)
        end
      end
    end

  end
  
  def step_persisted?(step)
    step.present? && send("#{step}_step_persisted?")
  end

  def step_valid?(step)
    send("#{step}_step_valid?")
  end
  
  def wizard_complete?
    WIZARD_STEPS.map { |s| step_persisted?(s) }.all?
  end
  
  def remaining_wizard_steps
    WIZARD_STEPS.reject { |s| step_persisted?(s) }
  end

  def remaining_wizard_steps_count
    remaining_wizard_steps.size
  end
  
  def description_step_done?
    errors.blank? && title.present? && name.present? && about.present?
  end
  
  def description_step_valid?
    errors.blank? && user.has_avatar? && title.present? && name.present? && about.present?
  end

  def avatar_step_valid?
    errors.blank? && !remove_avatar
  end

  def pictures_step_valid?
    errors.blank? && pictures.present?
  end

  def music_step_valid?
    errors.blank? && (has_youtube? || has_soundcloud?)
  end
  
  def concatenated_steps(step)
    wizard_state.to_s.split(",").push(step).join(",")
  end
  
  def assign_description_step!
    unless step_persisted?(:description)
      self.wizard_step = :description
      save validation: false
    end
  end

  private
  
  def assign_step
    if wizard_step.present? 
      if step_valid?(wizard_step)
        self.wizard_state = concatenated_steps(wizard_step) unless step_persisted?(wizard_step)
      else
        self.wizard_state = wizard_state.to_s.gsub(wizard_step.to_s, "").split(",").compact.join(",")
      end
    end
  end
  
  def assign_pictures_step!(picture)
    unless step_persisted?(:pictures)
      self.wizard_step = :pictures
      save validation: false
    end
  end

  def unassign_pictures_step!(picture)
    if step_persisted?(:pictures)
      self.wizard_step = :pictures
      save validation: false
    end
  end
  

end