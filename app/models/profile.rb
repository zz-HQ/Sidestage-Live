class Profile < ActiveRecord::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  extend FriendlyId
  
  include Profile::Presentable, Profile::Wizardable, Sortable, Filter, Payoutable
  
  acts_as_taggable
  
  mount_uploader :avatar, ProfileAvatarUploader

  paginates_per 24

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  ARTIST_TYPES_HUMAN = { solo: "solo musicians", band: "bands", dj: "DJs" }
  
  enum artist_type: { solo: 0, band: 1, dj: 2 }
  
  store :additionals, accessors: [ :admin_disabled_at, :youtube, :soundcloud, :twitter, :facebook, :cancellation_policy, :availability ]
  
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
  validates :price, numericality: { greater_than: 24 }, allow_blank: true

  validates :location, presence: true, if: :geo_step?
  validate :validate_location

  with_options if: :name_sub_step? do |profile|
    profile.validates :name, length: { maximum: 35 }
    profile.validates :name, presence: true
    profile.validates :slug, uniqueness: { case_sensitive: false }, allow_blank: true
  end
  
  
  with_options if: :about_sub_step? do |profile|
    profile.validates :about, presence: true
    profile.validate :urls_not_allowed_in_about, :email_address_not_allowed_in_about
  end  
  
  with_options if: :title_sub_step? do |profile|
    profile.validates :title, presence: true
    profile.validate :urls_not_allowed_in_title, :email_address_not_allowed_in_title
  end


  validate :should_have_youtube, if: :youtube_sub_step?
  validate :should_have_soundcloud, if: :soundcloud_sub_step?

  with_options on: :publishing do |profile|
    profile.validates :wizard_complete?, inclusion: [true]
    profile.validates :admin_disabled?, inclusion: [false]
    profile.validates :user_confirmed?, inclusion: [true]
  end
  
  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  sortable :price, :name, :location, :mobile_nr, :unread_message_counter, :email
  
  filterable :artist_type
  
  scope :published, -> { where("published_at IS NOT NULL") }
  scope :unpublished, -> { where("published_at IS NULL") }
  scope :featured, -> { where(featured: true) }
  scope :latest, -> { order("profiles.id DESC") }
  scope :radial, ->(lat, lng, radius) {
    unless lat.blank? || lng.blank? || radius.blank?
      where("#{Graticule::Distance::Spherical.to_sql(:latitude => lat, :longitude => lng, :units => :kilometers)} <= ?", radius) 
    end
  }
  scope :by_location, ->(location) { where(location: location) }
  scope :by_artist_type, ->(artist_type) { where(artist_type: artist_type) }
    
  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  before_validation :set_default_currency, on: :create

  after_validation :reverse_friendly
  
  after_save :notify_admin_on_publish, :send_publishing_confirmation
  
  
  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  belongs_to :user
  
  has_many :reviews, dependent: :delete_all
  has_many :pictures, -> { order("position ASC") }, as: :imageable, after_add: :assign_pictures_step!, after_remove: :unassign_pictures_step!
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
  delegate :confirmed?, to: :user, prefix: true
  
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
  
  def contestant_prices
    Profile.published.where("id != ?", id).by_artist_type(artist_type).radial(latitude, longitude, 180).select("profiles.currency, profiles.price")
  end
  
  def london?
    location == "London"
  end  
  
  def toggle!
    update_attribute :published_at, (published? ? nil : Time.now) if published? || valid?(:publishing)
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
    (iban.present? && bic.present?) || ()
  end

  def soundcloud_id_from_iframe(iframe)
    begin
      if iframe.include?("users")
        iframe.scan(/https%3A\/\/api.soundcloud.com\/users\/(\d*)/)[0][0]
      elsif iframe.include?("playlists")
        iframe.scan(/https%3A\/\/api.soundcloud.com\/playlists\/(\d*)/)[0][0]
      else
        iframe.scan(/https%3A\/\/api.soundcloud.com\/tracks\/(\d*)/)[0][0]
      end
      rescue Exception => e
        return nil
    end
  end

  def has_youtube?
    youtube.present? && youtube =~ /\A(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})\z/
  end

  def has_pictures?
    pictures.present?
  end
  
  def has_soundcloud?
    !!soundcloud_id_from_iframe(soundcloud)
  end
  
  def published?
    published_at.present?
  end
  
  def has_avatar?
    self[:avatar].present?
  end
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  private
  
  def reverse_friendly
    if description_step? && errors.present?
      errors.add friendly_id_config.base, errors[friendly_id_config.slug_column.to_sym] if errors.include?(friendly_id_config.slug_column.to_sym)
      send "#{friendly_id_config.slug_column}=", send("#{friendly_id_config.slug_column}_was")
    end
  end
  
  def notify_admin_on_publish
    if published_at_changed? && published?
      AdminMailer.delay.profile_published(self)
    end
  end
  
  def send_publishing_confirmation
    if published_at_changed? && published?
      EmailWorker.perform_async(:profile_published_confirmation, id)
    end
  end
  
  def set_default_currency
    self.currency ||= Currency.dollar.name
  end
  
  #
  # Validation methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  def urls_not_allowed_in_about
    errors.add :about, :includes_url if URI::extract(about.to_s, ["http", "https", "ftp"]).present? || about.to_s[/www\./]
  end

  def email_address_not_allowed_in_about
    errors.add :about, :includes_url if about.to_s[Devise::EMAIL_REGEXP_WORD]
  end

  def urls_not_allowed_in_title
    errors.add :title, :includes_url if URI::extract(title.to_s, ["http", "https", "ftp"]).present? || title.to_s[/www\./]
  end

  def email_address_not_allowed_in_title
    errors.add :title, :includes_url if title.to_s[Devise::EMAIL_REGEXP_WORD]
  end
  
  def should_have_soundcloud
    errors.add :soundcloud, :invalid unless soundcloud.blank? || !!soundcloud_id_from_iframe(soundcloud)
  end
  
  def should_have_youtube
    errors.add :youtube, :invalid unless youtube.blank? || has_youtube?
  end
  
  def should_have_picture
    errors.add :pictures, :blank unless has_pictures?
  end

  def validate_location
    errors.add :location, :select_suggestion if location_changed? && !latitude_changed? && !longitude_changed?
  end
    
end
