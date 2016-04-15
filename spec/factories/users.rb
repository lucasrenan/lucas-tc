FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@test.com" }
    password '123456789'
    role User::ROLES.first
  end
end
