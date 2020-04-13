FactoryBot.define do
  factory :vote do
    value { 1 }
    trait :for_comment do
      association :votable, factory: :comment
    end
    trait :for_post do
      association :votable, factory: :post
    end
    association :voter, factory: :user
  end
end
