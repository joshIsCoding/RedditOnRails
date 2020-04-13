FactoryBot.define do
  factory :post_sub do
    association :sub
    association :post
  end
end
