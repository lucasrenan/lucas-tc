FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@test.com" }
    password '123456789'
    role User.roles[:guest]
  end

  trait :admin do
    role User.roles[:admin]
  end

  trait :user do
    role User.roles[:user]
  end

  trait :guest do
    role User.roles[:guest]
  end
end
