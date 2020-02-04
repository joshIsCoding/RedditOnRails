require 'support/auth_helper'
require 'rails_helper'

RSpec.describe "User Authentication", type: :system do
  let(:new_username) { "new_user" }
  let(:existing_user) { User.create!(username: "existing_user", password: "test_pass")}
  describe "User Registration" do

    it "has a registration page" do
      visit(register_path)
      expect(page).to have_selector("form.user")
    end

    context "when valid credentials are provided" do
      before(:each) do
        register(new_username)
      end
      
      it "redirects to the home page" do
        expect(page).to have_current_path(root_path)
      end
      
      it "shows the user's username in the header bar" do
        expect(find("header h6")).to have_content(new_username)
      end
    end
    
    context "when invalid credentials are submitted" do
      it "refreshes the form with an error" do
        register(new_username, "fail")
        expect(page).to have_current_path(users_path)
        expect(page).to have_content("too short")
      end
    end
  end

  describe "User Login" do

    it "has a login page" do
      visit(login_path)
      expect(page).to have_selector("form.user")
    end

    context "when valid credentials are provided" do
      before(:each) do
        login(existing_user)
      end

      it "redirects to the home page" do
        expect(page).to have_current_path(root_path)
      end

      it "shows the user's username in the header bar" do
        expect(find("header h6")).to have_content(existing_user.username)
      end
    end
    
    context "when invalid credentials are submitted" do
      it "refreshes the form with an error" do
        login(existing_user, "not_right_pass")
        expect(page).to have_current_path(session_path)
        expect(page).to have_content("Invalid credentials")
      end
    end
  end
end