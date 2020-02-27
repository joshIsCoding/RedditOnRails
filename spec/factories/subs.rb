FactoryBot.define do
  factory :sub do
    sequence(:title) { |n| "sub_#{n}" }
    description { "MyText" }
    association :moderator, factory: :user
  end
end
