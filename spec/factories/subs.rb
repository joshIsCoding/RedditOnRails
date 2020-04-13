FactoryBot.define do
  factory :sub do
    sequence(:title) { |n| "Sub #{n}" }
    sequence(:name) { |n| "sub#{n}" }
    description { "Text relating to #{name}" }
    association :moderator, factory: :user
    factory :sub_with_posts do
      transient do
        posts_count { 5 }
      end  
      after :create do |sub, evaluator|
        create_list(:post, evaluator.posts_count, subs: [sub] )
      end
    end
    
  end
end
