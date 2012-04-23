class Venue < ActiveRecord::Base
  
  include YmCore::Model
  
  include Organisation
  
  #has_snippets :address1, :address2, :address3, :address4, :postcode, :phone, :region, :email
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode#,  :if => lambda{ |obj| obj.address_changed? }
  
  scope :with_lat_lng, where("lat IS NOT NULL AND lng IS NOT NULL")
  
  has_snippets :phone, :email
  
  validates :email, :email => true, :allow_blank => true
  validates :region, :presence => true
  
  belongs_to :promoter  
  
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