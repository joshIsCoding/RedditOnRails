FactoryBot.define do
  factory :comment do
    sequence( :contents ) { |n| "This is comment #{n}" }
    association :author, factory: :user
    association :post
  end
end
