class Profile < ActiveRecord::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
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
  
  attr_accessor :wizard_step
  
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
  validates :title, :name, :about, presence: true, if: :description_step?
  validates :price, numericality: true, allow_blank: true
  
  validates :genre_ids, :price, :title, :name, :about, presence: true, on: :publishing
  
  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  sortable :price
  
  filterable :location, :price
  
  scope :published, -> { where(published: true) }

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
  
end
