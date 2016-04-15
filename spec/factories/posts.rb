FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "post title - #{n}" }
    text 'post text'
    user
  end
end
