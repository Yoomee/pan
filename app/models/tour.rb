class Tour < ActiveRecord::Base
  
  include YmCore::Model
  include HasReviews
  
  define_index do
    indexes name, :sortable => true
    indexes description
    indexes genre_tags(:name), :as => :genres
    indexes collection_tags(:name), :as => :collections
    indexes booked_venues(:region), :as => :region 
    has created_at, updated_at
  end
  
  image_accessor :image
  
  belongs_to :performer
  has_many :dates, :class_name => "TourDate", :dependent => :destroy, :autosave => true, :order => "date ASC"
  
  has_many :booked_venues, :class_name => "Venue", :source => :venue, :through => :dates, :conditions => "tour_dates.booked = 1 AND tour_dates.venue_id != 0"
  
  has_many :links, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :links, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :reviews, :dependent => :nullify
  
  has_many :external_reviews, :as => :reviewable, :dependent => :destroy
  accepts_nested_attributes_for :external_reviews, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :posts, :as => :target
  
  date_accessors :start_on, :end_on
  
  acts_as_taggable_on :genres
  has_many :genre_tags, :through => :taggings, :source => :tag, :class_name => "ActsAsTaggableOn::Tag",
          :conditions => "taggings.context = 'genres'"

  acts_as_taggable_on :collections
  has_many :collection_tags, :through => :taggings, :source => :tag, :class_name => "ActsAsTaggableOn::Tag",
          :conditions => "taggings.context = 'collections'"
  
  accepts_nested_attributes_for :dates, :reject_if => :all_blank, :allow_destroy => true
  
  validates :name, :performer, :presence => true
  validates :min_playing_area, :numericality => true, :allow_blank => true
  validates_associated :dates
  validates_property :format, :of => :image, :in => [:jpeg, :jpg, :png, :gif], :message => "must be an image"
  
  delegate :contact1_name, :contact1_email, :contact1_phone, :contact2_name, :contact2_email, :contact2_phone, :contact1_details, :contact2_details, :to => :performer
  
  scope :past, joins(:dates).where("booked = 1 && tour_dates.date < ?", Date.today).group("tours.id")
  scope :future, joins(:dates).where("booked = 1 && tour_dates.date >= ?", Date.today).group("tours.id")
  
  def self.present_directory_letters
    order(:name).select("UCASE(SUBSTR(name,1,1)) AS letter").group("SUBSTR(name,1,1)").collect(&:letter) #reject{|let| let.blank?}
  end
  
  def name_with_performer
    "#{performer} - #{name}"
  end
  
  def name_with_dates
    "#{name} #{dates_string}".strip
  end
  
  def dates_string
    date_format = "%o %b %Y"
    if all_present?(:start_on, :end_on)
      DateTimeSpan.new(start_on, end_on, date_format).to_s
    else
      start_on.try(:strftime, date_format) || end_on.try(:strftime, date_format)
    end
  end
  
  def booked_dates
    dates.where(:booked => true)
  end
  
  
  def links_or_performer_links
    links.presence || performer.links
  end
   
  def links_or_performer_links_only_twitter_and_facebook
    links = links.presence || performer.links
    links.where("host = 'facebook.com' OR host = 'twitter.com'")
  end
  
  def links_or_performer_links_without_twitter_and_facebook
    links = links.presence || performer.links
    links.where("host != 'facebook.com' AND host != 'twitter.com'")
  end
  
  # def regions
  #   dates.where("booked = true AND venue_id != 0").collect{|date| date.venue.region}.uniq.join(" ")
  # end
  
  def sibling_tours
    performer.tours.without(self)
  end
  
  def summary
    
  end
  
  def technical_details
    [
      ["Do you need a blackout?", blackout_needed?],
      ["Do you use lighting?", uses_lighting?],
      ["Do you tour your own lighting?", uses_own_lighting?],
      ["Do you use sound?", uses_sound?]
    ]
  end
  
  def venues
    dates.joins(:venue).collect(&:venue).uniq
  end
  
  def venue_names
    venues.collect(&:name)
  end
  
  def venue_suitability
    [
      ["Arts venue", suits_arts_venue?],
      ["Village/community hall", suits_village_hall?],
      ["School hall", suits_school_hall?],
      ["Outdoors", suits_outdoors?]
    ]
  end
  
end