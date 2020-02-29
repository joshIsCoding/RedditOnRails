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
  end
end
