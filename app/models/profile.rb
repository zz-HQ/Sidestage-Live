class Profile < ActiveRecord::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  extend FriendlyId
  include Profile::Presentable
  include Sortable
  include Filter
  include Surcharge

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  CANCELLATION_POLICY = {
    flexible: 'activerecord.attributes.profile.cancellation_policy.flexible',
    moderate: 'activerecord.attributes.profile.cancellation_policy.moderate',
    strict: 'activerecord.attributes.profile.cancellation_policy.strict'
  }

  AVAILABILITY = {
    city: 'activerecord.attributes.profile.availability.city',
    state: 'activerecord.attributes.profile.availability.state',
    world: 'activerecord.attributes.profile.availability.world'
  }
  
  store :additionals, accessors: [ :youtube, :soundcloud, :twitter, :facebook, :cancellation_policy, :availability ]
  store :payout, accessors: [ :iban, :bic ]
  
  attr_accessor :wizard_step
  
  friendly_id :name do |config|
    config.use [:slugged, :finders]
    config.use Module.new{ def resolve_friendly_id_conflict(candidates);  candidates.first; end }
    config.use Module.new{ def should_generate_new_friendly_id?; name_changed? || super; end }
    config.use Module.new{ def to_param; friendly_id.presence.to_param || ((persisted? && key = to_key) ? key.join('-') : nil); end }
  end
  
  #
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  validates :user_id, :genre_ids, presence: true
  validates :price, presence: true, if: :price_step?
  
  with_options if: :description_step? do |profile|
    profile.validates :name, length: { maximum: 26 }
    profile.validates :title, :name, :about, presence: true
    profile.validates :slug, uniqueness: { case_sensitive: false }, allow_blank: true
  end
  
  validates :price, numericality: true, allow_blank: true
  validates :bic, :iban, presence: true, if: :payment_step?

  validates :genre_ids, :price, :title, :name, :about, presence: true, on: :publishing
  
  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  sortable :price, :name
  
  filterable :location, :price
  
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where("published = ? OR published = ?", nil, false) }
  scope :featured, -> { where(featured: true) }
  
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  after_validation :reverse_friendly
  
  after_save :notify_admin_on_publish

  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  belongs_to :user
  
  has_many :reviews, dependent: :delete_all
  has_many :pictures, as: :imageable
  accepts_nested_attributes_for :pictures, allow_destroy: true, reject_if: :all_blank
  
  has_and_belongs_to_many :genres  

  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  def self.find_reviewable(id)
    published.find(id)
  end
  
  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  def toggle!
    update_attribute :published, !published
  end
  
  def publishable?
    valid?(:publishing)
  end
  
  def payoutable?
    iban.present? && bic.present?
  end
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  private
  
  def price_step?
    wizard_step == :pricing
  end
  
  def description_step?
    wizard_step == :description
  end

  def payment_step?
    wizard_step == :payment
  end
  
  def reverse_friendly
    if description_step? && errors.present?
      errors.add friendly_id_config.base, errors[friendly_id_config.slug_column.to_sym] if errors.include?(friendly_id_config.slug_column.to_sym)
      send "#{friendly_id_config.slug_column}=", send("#{friendly_id_config.slug_column}_was")
    end
  end
  
  def notify_admin_on_publish
    if published_changed? && published?
      AdminMailer.delay.profile_published(self)
    end
  end
  
end
