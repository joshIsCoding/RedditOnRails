require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:title) }
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
    it { is_expected.to belong_to(:sub) }
    it { is_expected.to belong_to(:author) }
  end
end
