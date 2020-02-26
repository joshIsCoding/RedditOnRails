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
    it { is_expected.to belong_to(:author) }
  end
end
