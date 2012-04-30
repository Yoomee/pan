class Venue < ActiveRecord::Base
  

  include Organisation
  
  belongs_to :promoter
  belongs_to :user
  has_many :tour_dates, :dependent => :nullify
  
  acts_as_taggable_on :floor_surfaces, :power_sources
  
  has_snippets :keyholder_name, :keyholder_email, :keyholder_phone
  has_slideshow
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  
  after_validation :geocode,  :if => lambda{ |obj| obj.address_changed? }
  
  scope :with_lat_lng, where("lat IS NOT NULL AND lng IS NOT NULL")
  
  validates :region, :presence => true
  
  def address
    %w{address1 address2 city postcode country}.map {|fld| send(fld)}.select(&:present?).join(', ')
  end
  
  def address_changed?
    address1_changed? || address2_changed? || city_changed? || postcode_changed?
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
    (image || default_image).thumb("80x80#").url
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
  
end

Venue::DEFAULT_LOCATION = [58.031372,-4.086914]
