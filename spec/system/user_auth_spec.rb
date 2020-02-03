require 'rails_helper'

RSpec.describe "User Authentication", type: :system do
  let(:new_user) { User.new(username: "new_user", password: "test_pass")}
  let(:existing_user) { User.create!(username: "existing_user", password: "test_pass")}
  describe "User Registration" do
    before(:each) { visit(register_path) }

    it "has a registration page" do
      expect(page).to have_selector("form.user")
    end

    context "when valid credentials are provided" do
      before(:each) do
        within 'form.user' do
          fill_in 'user_username', with: new_user.username 
          fill_in 'user_password', with: new_user.password
          click_button 'SIGN UP'
        end
      end
      
      it "redirects to the home page" do
        expect(page).to have_current_path(root_path)
      end
      
      it "shows the user's username in the header bar" do
        expect(find("header h6")).to have_content(new_user.username)
      end
    end
    
    context "when invalid credentials are submitted" do
      it "refreshes the form with an error" do
        within 'form.user' do
          fill_in 'user_username', with: new_user.username 
          fill_in 'user_password', with: "test"
          click_button 'SIGN UP'
        end
        expect(page).to have_current_path(users_path)
        expect(page).to have_content("too short")
      end
    end
  end

  describe "User Login" do
    before(:each) { visit(login_path) }

    it "has a login page" do
      expect(page).to have_selector("form.user")
    end

    context "when valid credentials are provided" do
      before(:each) do
        within 'form.user' do
          fill_in 'user_username', with: existing_user.username 
          fill_in 'user_password', with: existing_user.password
          click_button 'SIGN IN'
        end
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
        within 'form.user' do
          fill_in 'user_username', with: existing_user.username 
          fill_in 'user_password', with: "not_right_pass"
          click_button 'SIGN IN'
        end
        expect(page).to have_current_path(session_path)
        expect(page).to have_content("Invalid credentials")
      end
    end
  end
end