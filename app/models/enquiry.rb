class Enquiry < ActiveRecord::Base
  
  include YmEnquiries::Enquiry

  before_save :sort_dates_interested_in

  private
  def sort_dates_interested_in
    if form_name == "interested"
      unless dates_interested_in == "Not sure yet"
        self.dates_interested_in = dates_interested_in.split(',').collect{|m| Date.parse(m)}.sort.collect{|m| m.to_s(:date)}.join(', ')
      end
    end
  end
  
end