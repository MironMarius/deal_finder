FactoryBot.define do
  factory :deal_location do
    association :deal
    association :location
  end
end
