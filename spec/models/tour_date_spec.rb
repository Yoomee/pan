require 'spec_helper'

describe TourDate do
  
  let(:tour_date) {FactoryGirl.create(:tour_date)}
  
  it "is valid" do
    tour_date.should be_valid
  end
  
  describe "setting date_s" do
    
    it "sets date correctly" do
      tour_date.date_s = "24/04/2012"
      tour_date.date.should == Date.strptime("24/04/2012", "%d/%m/%Y")
    end
    
    it "doesn't set date if date_s is invalid" do
      original_date = tour_date.date
      tour_date.date_s = "invalid_date"
      tour_date.date.should == original_date
    end
    
    it "sets date to nil if date_s is blank" do
      tour_date.date_s = ""
      tour_date.date.should == nil
    end
    
  end
  
end