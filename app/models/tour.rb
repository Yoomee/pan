class Tour < ActiveRecord::Base
  
  include YmCore::Model
  
  image_accessor :image
  
  belongs_to :performer
  has_many :dates, :class_name => "TourDate", :dependent => :destroy, :autosave => true, :order => "date ASC"
  
  date_accessors :start_on, :end_on
  
  acts_as_taggable_on :genres
  
  accepts_nested_attributes_for :dates, :reject_if => :all_blank, :allow_destroy => true
  
  validates :name, :performer, :presence => true
  validates :min_playing_area, :numericality => true, :allow_blank => true
  validates_associated :dates
  validates_property :format, :of => :image, :in => [:jpeg, :jpg, :png, :gif], :message => "must be an image"
  
  delegate :contact1_name, :contact1_email, :contact1_phone, :contact2_name, :contact2_email, :contact2_phone, :contact1_details, :contact2_details, :to => :performer
  
  scope :past, joins(:dates).where("booked = 1 && tour_dates.date < ?", Date.today).group("tours.id")
  scope :future, joins(:dates).where("booked = 1 && tour_dates.date >= ?", Date.today).group("tours.id")
  
  def name_with_performer
    "#{performer} - #{name}"
  end
  
  def name_with_dates
    return name if !all_present?(:start_on, :end_on)
    dts = DateTimeSpan.new(start_on, end_on, "%o %b %Y")
    "#{name} #{dts}"
  end
  
  def booked_dates
    dates.where(:booked => true)
  end
  
  def sibling_tours
    performer.tours.without(self)
  end
  
  def technical_details
    [
      ["Do you need a blackout?", blackout_needed?],
      ["Do you use lighting?", uses_lighting?],
      ["Do you tour your own lighting?", uses_own_lighting?],
      ["Do you use sound?", uses_sound?]
    ]
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