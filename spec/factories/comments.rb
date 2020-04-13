FactoryBot.define do
  factory :comment do
    contents { "MyText" }
    association :author, factory: :user
    association :post
  end
end
