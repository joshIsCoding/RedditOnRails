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
    let( :sub ) { create :sub }
    let(:posts) { create_list( :post, 3, subs: [ sub ] )}
    before do
      create_list( :vote, 3, votable: posts[1] )
      create_list( :vote, 2, votable: posts[0] )
    end
    subject(:sorted_posts) { sub.posts.with_votes.sort_by_votes }

    describe "#sort_by_votes scope" do

      it "should return posts sorted by their total vote score" do
        expect(sorted_posts).to eq([ posts[1], posts[0], posts[2]])
      end

      it "should return posts with a score psuedo-attribute" do
        expect(sorted_posts.first.vote_sum).to eq(3)
        expect(sorted_posts.last.vote_sum).to eq(0)
      end
    end
  end
end
