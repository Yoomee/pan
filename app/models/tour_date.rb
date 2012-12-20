class TourDate < ActiveRecord::Base
  
  include YmCore::Model
  include YmActivity::Recordable
  
  belongs_to :tour
  belongs_to :venue
  belongs_to :user
  
  date_accessor :date
  
  validates :date, :date_s, :presence => true
  validates :tour, :presence => true, :on => :update
  
  scope :past, where(:booked => true).where("date < ?", Date.today)
  scope :future, where(:booked => true).where("date >= ?", Date.today)
  scope :in_pan_venue, where('venue_id != 0 AND venue_id IS NOT NULL')
  
  def to_hash
    {
      :booked => booked,
      :venue_id => venue.try(:try)
    }
  end
  
  def venue_name
    (venue || external_venue_name).to_s
  end
  
  def confirm_booking
    update_attributes(:needs_approval => 0, :booked => 1)
  end
  
end