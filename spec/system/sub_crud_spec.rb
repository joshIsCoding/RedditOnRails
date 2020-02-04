require 'support/auth_helper'
require 'rails_helper'

RSpec.describe "User Authentication", type: :system do
  let(:main_user) { User.create!(username: "Main_user", password: "test_pass")}
  let(:other_user) { User.create!(username: "Other_user", password: "test_pass")}

  describe "Sub#show" do
    let!(:show_sub) do 
      Sub.create!(
        title: "Shows", 
        description: "For talking about shows",
        moderator: main_user
        )
      end
    context "when not logged in" do
      it "shows the sub's title and description" do
        visit(sub_path(show_sub))
        expect(page).to have_content(show_sub.title)
        expect(page).to have_content(show_sub.description)
      end
    end

    context "when logged in" do
      it "still shows the sub's title and description" do
        login(main_user)
        visit(sub_path(show_sub))
        expect(page).to have_content(show_sub.title)
        expect(page).to have_content(show_sub.description)
      end
    end

  end

  describe "Sub#index" do
    
    context "when not logged in" do
      it "shows all subs"
    end

    context "when logged in" do
      it "shows all subs"
    end
  end

end