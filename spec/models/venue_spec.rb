require 'spec_helper'

describe Venue do
  
  let(:venue) {FactoryGirl.create(:venue)}
  
  it "should be valid" do
    venue.should be_valid
  end
    
  
end