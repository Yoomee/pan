FactoryGirl.define do

  factory :company do
    name "Mumford and Sons"
  end
  
  factory :promoter do
    name "Shetland Arts Development Agency"
    region "Northern Isles"
  end
  
  factory :venue do
    name "Garrison Theatre"
    region "Northern Isles"
    association :promoter
  end
  
  factory :tour do
    name "A Tour"
    association :company
  end
  
  factory :tour_date do
    date 1.week.from_now.to_date
    association :tour
    association :venue
  end
  
end