FactoryBot.define do
  factory :user, aliases: [:author, :moderator] do
    sequence(:username) { |n| "user_#{n}" }
    password { "password" }
  end
end
