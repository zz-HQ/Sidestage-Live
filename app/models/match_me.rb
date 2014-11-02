class MatchMe
  include ActiveModel::Model, ActiveModel::Validations
  
  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  TRAVERSABLE_ATTRIBUTES = [:event, :genre, :total_visitors, :max_budget, :event_date, :zip_code, :phone_number, :name, :email, :comment, :newsletter_subscribed]
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
    mm.validates :email, format: { with: Devise::EMAIL_REGEXP }
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
      MailchimpSubscriber.new(name: name, email: email).save
      return true
    else
      return false
    end
  end
  
  def newsletter_subscribed
    @newsletter_subscribed.nil? ? true : ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(@newsletter_subscribed)
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