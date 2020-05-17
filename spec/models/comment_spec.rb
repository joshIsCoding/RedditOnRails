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
    let( :post ) { create :post }
    let(:comments) { create_list( :comment, 3, post: post ) }
    before do
      create_list( :vote, 3, votable: comments[1] )
      create_list( :vote, 2, votable: comments.last )
    end
    subject(:sorted_comments) { post.comments.with_votes.sort_by_votes }

    describe "#sort_by_votes scope" do

      it "should return comments sorted in descending order by their total vote score" do
        expect(sorted_comments).to eq([comments[1], comments[2], comments[0]])
      end

      it "should return comments with a score psuedo-attribute" do
        expect(sorted_comments.first.vote_sum).to eq(3)
        expect(sorted_comments.last.vote_sum).to eq(0)
      end
    end
  end
end
