FactoryGirl.define do
  factory :device do
    sequence(:name) { |n| "device name - #{n}" }
    user
  end
end
