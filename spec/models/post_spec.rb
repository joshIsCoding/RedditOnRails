require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:subs) }
    it do 
      is_expected.to allow_values(
        "google.com", 
        "https://facebook.jp", 
        "www.rails.co.uk"
      ).for(:url)
    end

    it do 
      is_expected.to_not allow_values(
        "google", 
        "youtube .org",
        ".rails.com"
      ).for(:url)
    end
  end

  describe "Associations" do
    it { is_expected.to have_many(:post_subs).dependent(:destroy) }
    it { is_expected.to have_many(:subs) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:votes).dependent(:destroy) }
    it { is_expected.to belong_to(:author) }
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
    let(:posts) do 
      p = []
      3.times do |i|
        p << Post.create!(
          title: "Post_#{i+1}",
          content: "Post contents",
          subs: [sub],
          author: users.first
        )
      end
      p
    end
    let!(:votes) do
      posts.each_with_index do |post, i|
        i.times { |j| Vote.create!(votable: posts[i], voter: users[j]) }
      end
    end
    subject(:sorted_posts) { sub.posts.sort_by_votes }
    describe "#sort_by_votes scope" do
      it "should return posts sorted by their total vote score" do
        expect(sorted_posts).to eq(posts.reverse)
      end
      it "should return posts with a score psuedo-attribute" do
        expect(sorted_posts.first.vote_sum).to eq(2)
        expect(sorted_posts.last.vote_sum).to eq(0)
      end
    end
  end
end
