FactoryGirl.define do

  factory :company do
    name "Mumford and Sons"
  end
  
  factory :promoter do
    name "Shetland Arts Development Agency"
    region "Northern Isles"
  end
  
  factory :venue do |f|
    name "Garrison Theatre"
    region "Northern Isles"
    association :promoter
  end
  
end