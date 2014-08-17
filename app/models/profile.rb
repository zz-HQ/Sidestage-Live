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
  
  WIZARD_STEPS = [:pricing, :description, :payment, :soundcloud, :youtube]
  
  store :additionals, accessors: [ :admin_disabled_at, :youtube, :soundcloud, :twitter, :facebook, :cancellation_policy, :availability ]
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
  validates :price, presence: true, if: :pricing_step?
  validates :price, numericality: { greater_than: 0 }, allow_blank: true
  validates :youtube, format: { with: (/\A(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})\z/) }
  
  with_options if: :description_step? do |profile|
    profile.validates :name, length: { maximum: 26 }
    profile.validates :title, :name, :about, presence: true
    profile.validates :slug, uniqueness: { case_sensitive: false }, allow_blank: true
  end
  validates :bic, :iban, presence: true, if: :payment_step?

  validate :should_have_youtube, if: :youtube_step?
  validate :should_have_soundcloud, if: :soundcloud_step?

  with_options on: :publishing do |profile|
    profile.validates :genre_ids, :price, :title, :name, :about, presence: true
    profile.validates :admin_disabled?, inclusion: [false]
    profile.validate :mobile_nr_must_be_confirmed
    profile.validate :should_have_at_least_one_media_type
    profile.validate :user_must_have_avatar
  end
  
  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  sortable :price, :name, :location, :mobile_nr, :unread_message_counter, :email
  
  filterable :location, :price
  
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where("published = ? OR published = ?", nil, false) }
  scope :featured, -> { where(featured: true) }
  scope :latest, -> { order("profiles.id DESC") }
  
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
  # Delegates
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  delegate :mobile_nr_confirmed?, to: :user, prefix: false

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
    update_attribute :published, !published if published? || valid?(:publishing)
  end
  
  def toggle_admin_disabled!
    self.admin_disabled_at = admin_disabled_at.present? ? nil : Time.now
    save!
  end
  
  def admin_disabled?
    self.admin_disabled_at.present?
  end
  
  def publishable?
    valid?(:publishing) && !admin_disabled?
  end
  
  def payoutable?
    iban.present? && bic.present?
  end

  def soundcloud_id_from_iframe(iframe)
    begin
      if iframe.include?("playlists")
        iframe.scan(/https%3A\/\/api.soundcloud.com\/playlists\/(\d*)/)[0][0]
      else
        iframe.scan(/https%3A\/\/api.soundcloud.com\/tracks\/(\d*)/)[0][0]
      end
      rescue Exception => e
        return nil
    end
  end

  def has_youtube?
    youtube.present? && youtube.include?("youtu")
  end

  def has_pictures?
    pictures.present?
  end
  
  def has_soundcloud?
    !!soundcloud_id_from_iframe(soundcloud)
  end
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  private
  
  WIZARD_STEPS.each do |step|
    define_method "#{step}_step?" do
      wizard_step == step
    end
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

  #
  # Validation methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  
  def mobile_nr_must_be_confirmed
    errors.add :published, :blank unless mobile_nr_confirmed?
  end
  
  def user_must_have_avatar
    errors.add :user, :avatar_blank unless user.avatar.present?
  end
  
  def should_have_soundcloud
    errors.add :soundcloud, :invalid unless !!soundcloud_id_from_iframe(soundcloud)
  end
  
  def should_have_youtube
    errors.add :youtube, :invalid unless has_youtube?
  end
  
  def should_have_picture
    errors.add :pictures, :blank unless has_pictures?
  end

  def should_have_at_least_one_media_type
    unless has_youtube? || !!soundcloud_id_from_iframe(soundcloud) || has_pictures?
      should_have_youtube || should_have_soundcloud || should_have_picture
    end
  end
  
end
