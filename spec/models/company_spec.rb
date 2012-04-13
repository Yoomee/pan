require 'spec_helper'

describe Company do
  
  let(:company) {FactoryGirl.create(:company)}
  
  it "should be valid" do
    company.should be_valid
  end
    
  
end