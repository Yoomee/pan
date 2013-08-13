class Venue < ActiveRecord::Base
  
  include Organisation
  include YmActivity::Recordable
  include HasLinks
  
  define_index do
    indexes name, :sortable => true
    indexes description
    indexes region
    has created_at, updated_at
  end
  
  
  belongs_to :promoter
  belongs_to :user
  has_many :booked_dates, :class_name => "TourDate", :dependent => :nullify
  accepts_nested_attributes_for :booked_dates, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :posts, :as => :target, :conditions => {:is_update => false}
  has_many :updates, :class_name => "Post", :as => :target, :conditions => {:is_update => true}
  
  has_many :resources, :as => :target
  accepts_nested_attributes_for :resources, :reject_if => :all_blank, :allow_destroy => true
  
  acts_as_taggable_on :floor_surfaces, :power_sources
  
  has_snippets :keyholder_name, :keyholder_email, :keyholder_phone
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  
  after_validation :geocode,  :if => lambda{ |obj| obj.address_changed? }
  
  scope :with_lat_lng, where("lat IS NOT NULL AND lng IS NOT NULL")
  
  validates :region, :presence => true
  
  def address
    [address1, address2, city, postcode, country].select(&:present?).join(', ')
  end
  
  def address_changed?
    address1_changed? || address2_changed? || city_changed? || postcode_changed?
  end
  
  def address_without_country
    [address1, address2, city, postcode].select(&:present?).join(', ')
  end
  
  def keyholder_details
    [keyholder_name, keyholder_email, keyholder_phone].compact
  end
  
  def country
    "UK"
  end
  
  def has_lat_lng?
    lat.present? && lng.present?
  end
  
  def infowindow_image_url
    img = (image || default_image)
    img.nil? ? '' : img.thumb("80x80#").url
  end
  
  def lat_lng_or_default
    has_lat_lng? ? [lat,lng] : Venue::DEFAULT_LOCATION
  end 
  
  def promoter=(promoter)
    # default to promoter's region
    self.region = promoter.region
  end
  
  def short_description
    description.truncate(190)
  end
  
  def tour_dates
    booked_dates.where("tour_id IS NOT NULL")
  end
  
end

Venue::DEFAULT_LOCATION = [58.031372,-4.086914]
