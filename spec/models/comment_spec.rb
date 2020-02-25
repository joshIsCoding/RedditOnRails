require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:contents) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:post).dependent(:destroy) }
    it { is_expected.to belong_to(:author).dependent(:destroy) }
  end
end
