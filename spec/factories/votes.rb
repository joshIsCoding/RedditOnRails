FactoryBot.define do
  factory :vote do
    value { 1 }
    votable { nil }
    voter { nil }
  end
end
