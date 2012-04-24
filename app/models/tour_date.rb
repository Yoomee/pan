class TourDate < ActiveRecord::Base
  
  include YmCore::Model
  
  belongs_to :tour
  belongs_to :venue
  
  validates :date, :venue, :presence => true
  validates :date_s, :date => true, :presence => true
  validates :tour, :presence => true, :on => :update
  
  def date_s
    @date_s || date.try(:strftime, "%d/%m/%Y") || ''
  end
  
  def date_s=(value)
    if value.blank?
      self.date = nil
    else
      begin
        self.date = Date.strptime(value, "%d/%m/%Y")
      rescue ArgumentError
      end
      @date_s = value
    end
  end
  
end