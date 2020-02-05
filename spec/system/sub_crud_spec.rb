require 'support/auth_helper'
require 'support/sub_helper'
require 'rails_helper'

RSpec.configure do |c|
  c.include AuthHelper
  c.include SubHelper
end

RSpec.describe "User Authentication", type: :system do
  let(:main_user) { User.create!(username: "Main_user", password: "test_pass")}
  let(:other_user) { User.create!(username: "Other_user", password: "test_pass")}

  describe "Sub#show" do
    let!(:show_sub) do 
      Sub.create!(
        name: "Shows",
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
    let!(:subs) do 
      subs = (1..3)
      subs.map do |i| 
        Sub.create!(
          name: "sub_#{i}", 
          title: "sub_#{i}", 
          description: "description_#{i}", 
          moderator: other_user 
        )
      end
    end
    
      context "when not logged in" do
        it "shows all subs" do
          visit(subs_path)
          subs.each do |sub|
            expect(page).to have_link(sub.title, href: /#{sub_path(sub)}$/)
            expect(page).to have_content(sub.description)
          end
        end
      end

    context "when logged in" do
      it "shows all subs" do
        login(main_user)
        visit(subs_path)
        subs.each do |sub|
          expect(page).to have_link(sub.title, href: /#{sub_path(sub)}$/)
          expect(page).to have_content(sub.description)
        end
      end
    end
  
  end

  describe "Sub Creation" do
    let(:valid_sub) do
      {
        "sub_name" => "new_sub",
        "sub_title" => "New Sub",
        "sub_description" => "This is a new sub."
      }
    end

    let(:invalid_sub) do
      {
        "sub_name" => "new sub",
        "sub_title" => "New Sub",
      }
    end

    context "when not logged in" do
      it "does not let the user create a sub." do
        visit(new_sub_path)
        expect(page).to have_current_path(login_path)
        expect(page).
        to have_content("You can only do that with a RedditOnRails account.")
      end
    end

    context "when logged in" do
      before(:each) do
        login(main_user)
        visit(new_sub_path)
      end 
      context "when the provided sub details are valid" do
        it "lets a user create the new sub" do
          create_sub(valid_sub)
          valid_sub.each_value do |sub_property|
            expect(page).to have_content(sub_property)
          end
        end
      end

      context "when the sub details are invalid" do
        it "refreshes the form with error messages" do
          create_sub(invalid_sub)
          expect(page).to have_content("cannot contain spaces")
          expect(page).to have_content("description cannot be")
        end
      end
      
    end
  end
end