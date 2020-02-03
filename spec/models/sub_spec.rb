require 'rails_helper'

RSpec.describe Sub, type: :model do
  let(:user) { User.new(username: "Tester", password: "testing") }
  subject(:sub) do 
    Sub.new(
      title: "Test Sub", 
      description: "The best sub",
      moderator: user
    )
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:moderator).with_foreign_key('user_id') }
  end

end
