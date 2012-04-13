require 'spec_helper'

describe Promoter do
  
  let(:promoter) {FactoryGirl.create(:promoter)}
  
  it "should be valid" do
    promoter.should be_valid
  end
    
  
end