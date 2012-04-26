class Venue < ActiveRecord::Base
  
  include YmCore::Model
  
  include Organisation
  
  belongs_to :promoter
  belongs_to :user
  has_many :tour_dates, :dependent => :nullify
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode#,  :if => lambda{ |obj| obj.address_changed? }
  
  scope :with_lat_lng, where("lat IS NOT NULL AND lng IS NOT NULL")
  
  validates :region, :presence => true
  
  def address
    %w{address1 address2 city postcode country}.map {|fld| send(fld)}.select(&:present?).join(', ')
  end
  
  def address_changed?
    address1_changed? || address2_changed? || city_changed? || postcode_changed?
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
  
  def promoter=(promoter)
    # default to promoter's region
    self.region = promoter.region
  end
  
  def short_description
    description.truncate(190)
  end
  
end