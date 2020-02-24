require 'rails_helper'

RSpec.describe PostSub, type: :model do
  describe "Validations" do
    it do
      sub = Sub.create!(
          name: "test",
          title: "test",
          description: "k",
          moderator: User.create!(username: "Test", password: "password")
        )
      post = Post.create!( title: "test", subs: [sub], author: User.first )

      is_expected.to validate_uniqueness_of(:sub_id).scoped_to(:post_id)
    end  
  end
  describe "Associations" do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:sub) }
  end
end