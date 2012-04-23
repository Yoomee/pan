class TourDate < ActiveRecord::Base
  
  include YmCore::Model
  
  belongs_to :tour
  belongs_to :venue
  
  before_validation :update_date
  
  attr_writer :date_s
  
  validates :date, :date_s, :presence => true
  validates :tour, :presence => true, :on => :update
  
  def date_s
    date.try(:strftime, "%d/%m/%Y") || ''
  end
  
  private
  def update_date
    self.date ||= Date.strptime(@date_s, "%d/%m/%Y") unless @date_s.blank?
  end
  
end