class Profile < ActiveRecord::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  include Priceable
  include Profile::Presentable
  include Sortable
  include Filter

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  CANCELLATION_POLICY = {
    flexible: 'activerecord.attributes.profile.cancellation_policy.flexible'
  }
  AVAILABILITY = {
    city: 'activerecord.attributes.profile.availability.city',
    state: 'activerecord.attributes.profile.availability.state',
    world: 'activerecord.attributes.profile.availability.world'
  }
  TRAVEL_COSTS = {
    myself: 'activerecord.attributes.profile.travel_costs.myself',
    shared: 'activerecord.attributes.profile.travel_costs.shared',
    customer: 'activerecord.attributes.profile.travel_costs.customer'
  }
  
  store :additionals, accessors: [ :youtube, :soundcloud, :late_night_fee, :night_fee, :cancellation_policy, :availability, :travel_costs ]

  #
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  validates :user_id, :genre_ids, presence: true
  validates :night_fee, :price, numericality: true, allow_blank: true
  
  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  sortable :price, :desc
  sortable :tagline, :desc
  
  filterable :price, :location
  
  scope :published, -> { where(published: true) }

  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  belongs_to :user
  
  has_many :pictures, as: :imageable
  accepts_nested_attributes_for :pictures, allow_destroy: true, reject_if: :all_blank
  
  has_and_belongs_to_many :genres  
  
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
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  private
  
end
