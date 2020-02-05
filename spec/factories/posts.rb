FactoryBot.define do
  factory :post do
    title { "MyString" }
    url { "MyString" }
    content { "MyText" }
    sub { nil }
    author { nil }
  end
end
