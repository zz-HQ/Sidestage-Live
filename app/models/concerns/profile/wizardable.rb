module Profile::Wizardable
  extend ActiveSupport::Concern
  
  included do
    WIZARD_STEPS = [:style, :location, :pricing, :description, :avatar, :pictures, :music]

    WIZARD_STEPS.each do |step|
      define_method "#{step}_step?" do
        wizard_step == step
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
  
  def style_step_done?
    persisted?
  end
  
  def location_step_done?
    location.present? && latitude.present? && longitude.present?
  end
  
  def pricing_step_done?
    price.present? && currency.present?
  end
  
  def description_step_done?
    name.present? && title.present? && about.present?
  end
  
  def avatar_step_done?
    avatar.present?
  end
  
  def pictures_step_done?
    pictures.present?
  end
  
  def music_step_done?
    has_youtube? && has_soundcloud?
  end
  
end