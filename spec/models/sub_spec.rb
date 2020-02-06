require 'rails_helper'

RSpec.describe Sub, type: :model do
  let(:user) { User.new(username: "Tester", password: "testing") }
  subject(:sub) do 
    Sub.new(
      name: "Test",
      title: "Test Sub", 
      description: "The best sub",
      moderator: user
    )
  end
  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_uniqueness_of(:title) }

    it do 
      is_expected.to_not allow_values("invalid name", "Another Invalid name").
      for(:name)
    end

    it do 
      is_expected.to allow_values("ValidName", "AnotherValidName").for(:name)
    end
  end

  describe "Associations" do
    it { is_expected.to belong_to(:moderator).with_foreign_key('user_id') }
    it { is_expected.to have_many(:posts) }
  end

end
