require 'rails_helper'

RSpec.describe Sub, type: :model do
  
  describe "Validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:moderator).class_name('User') }
  end

end
