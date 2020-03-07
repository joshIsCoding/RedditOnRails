require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:main_user) { User.create!(username: "main_user", password: "test_pass")}
  let(:other_user) { User.create!(username: "other_user", password: "test_pass")}
  let(:sub) do 
    Sub.create!(
      name: "Test",
      title: "Test Sub", 
      description: "The best sub",
      moderator: main_user
    )
  end
  let(:post) do 
    Post.create!(
      title: "Main Post",
      content: "User's Post",
      subs: [sub],
      author: main_user
    )
  end
  subject(:unqiue_vote) { Vote.create(voter: other_user, votable: post)}
  describe "Validations" do
    it { is_expected.to validate_inclusion_of(:value).in_array([1,-1]) }
    it { is_expected.to validate_uniqueness_of(:voter_id).scoped_to(:votable_id, :votable_type) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:votable) }
    it { is_expected.to belong_to(:voter).class_name('User') }
  end
end
