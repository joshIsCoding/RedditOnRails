require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { User.create(username: "main_user", password: "test_pass")}
  describe "Validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:password_digest) }
    it { is_expected.to validate_presence_of(:session_token) }

    it { is_expected.to validate_uniqueness_of(:username) }
    it do 
      is_expected.to validate_length_of(:password).
      is_at_least(5)
    end
    it { is_expected.to allow_value(nil).for(:password) }
  end

  
end
