require 'spec_helper'

describe Performer do
  
  let(:performer) {FactoryGirl.create(:performer)}
  
  it "should be valid" do
    performer.should be_valid
  end
    
  
end