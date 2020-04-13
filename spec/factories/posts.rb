FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post_#{n}" }
    sequence(:url) { |n| "http://#{title.downcase}.com" }
    content { "Content for #{title}" }
    association :author, factory: :user
    after(:build) do |post|
      unless post.subs.any?
        post.subs = [ create(:sub) ]        
      end
    end
  end
end
