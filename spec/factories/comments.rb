FactoryBot.define do
  factory :comment do
    contents { "MyText" }
    author { nil }
    post { nil }
  end
end
