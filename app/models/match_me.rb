class MatchMe
  include ActiveModel::Model, ActiveModel::Validations
  
  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  TRAVERSABLE_ATTRIBUTES = [:event, :genre, :total_visitors, :max_budget, :event_date, :zip_code, :phone_number, :name, :email, :comment]
  attr_accessor :wizard_step
  TRAVERSABLE_ATTRIBUTES.each do |a|
    attr_accessor a
  end
  
  
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  with_options if: :location_step? do |mm|
    mm.validate :email, presence: true
    mm.validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  end

  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def save
    if valid?
      AdminMailer.delay.match_me(self)
      return true
    else
      return false
    end
  end
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  private
  
  def location_step?
    wizard_step == :location
  end
  
end