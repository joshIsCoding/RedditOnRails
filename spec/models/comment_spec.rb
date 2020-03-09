require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:contents) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:parent_comment).optional }
    it { is_expected.to have_many(:child_comments) }
    it { is_expected.to have_many(:votes).dependent(:destroy) }
  end

  describe "Votes and Related Methods" do
    let(:users) do
      u = []
      3.times {|i| u << User.create!(username: "user_#{i+1}", password: "password")}
      u
    end
    let(:sub) do
      Sub.create!(
          name: "Main",
          title: "Main", 
          description: "For talking about everything.",
          moderator: users.first
        )
    end
    let(:post) do
      Post.create!(
        title: "Main Post",
        content: "User's Post",
        subs: [sub],
        author: users.first
      )
    end
    let(:comments) do 
      c = []
      3.times do |i|
        c << Comment.create!(
          post: post,
          contents: "Great comment #{i}",
          author: users.first
        )
      end
      c
    end
    let!(:votes) do
      comments.each_with_index do |post, i|
        i.times { |j| Vote.create!(votable: comments[i], voter: users[j]) }
      end
    end
    subject(:sorted_comments) { post.comments.sort_by_votes }
    describe "#sort_by_votes scope" do
      it "should return comments sorted by their total vote score" do
        expect(sorted_comments).to eq(comments.reverse)
      end
      it "should return comments with a score psuedo-attribute" do
        expect(sorted_comments.first.vote_sum).to eq(2)
        expect(sorted_comments.last.vote_sum).to eq(0)
      end
    end
  end
end
