require 'spec_helper'

describe Tour do
  
  let(:tour) {FactoryGirl.create(:tour)}
  
  it "should be valid" do
    tour.should be_valid
  end
  
end