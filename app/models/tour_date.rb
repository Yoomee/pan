class TourDate < ActiveRecord::Base
  
  include YmCore::Model
  
  belongs_to :tour
  belongs_to :venue
  
  date_accessor :date
  
  validates :date, :date_s, :presence => true
  validates :tour, :presence => true, :on => :update
  
  scope :past, where(:booked => true).where("date < ?", Date.today)
  scope :future, where(:booked => true).where("date >= ?", Date.today)
  
  def to_hash
    {
      :booked => booked,
      :venue_id => venue.try(:try)
    }
  end
  
  
end