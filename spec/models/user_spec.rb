require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:main_user) { User.create(username: "main_user", password: "test_pass")}
  describe "Validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:password_digest) }
    it { is_expected.to validate_presence_of(:session_token) }

    it { is_expected.to validate_uniqueness_of(:username) }
    it do 
      is_expected.to validate_length_of(:password).
      is_at_least(5)
    end
    it { is_expected.to validate_presence_of(:password).allow_nil }
  end

  describe "Associations" do
    it { is_expected.to have_many(:subs) }
  end

  describe "Methods" do
    describe "has_password?(password)" do
      context "when the correct password is provided" do
        it "returns true" do
          expect(main_user.has_password?(main_user.password)).to be true
        end
      end
      context "when an incorrect password is provided" do
        it "returns false" do
          expect(main_user.has_password?("incorrect_pass")).to be false
        end
      end
    end

    describe "::find_by_credentials(username, password)" do
      context "when an existing user's credentials are provided" do
        it "returns the user" do
          expect(User.find_by_credentials(main_user.username, main_user.password)).
          to eq(main_user)
        end
      end
      context "when partially correct or non-existant credentials are provided" do
        it "returns nil" do
          expect(User.find_by_credentials(main_user.username, "not_pass")).
          to be nil
          expect(User.find_by_credentials("no_user", "not_pass")).to be nil
        end
      end
    end

    describe "#reset_session_token!" do
      it "changes the session_token in the database" do
        old_token = main_user.session_token
        main_user.reset_session_token!
        main_user.valid?
        expect(main_user.session_token).to_not eq(old_token)
      end
    end
  end
end
