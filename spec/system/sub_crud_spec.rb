require 'support/auth_helper'
require 'support/form_helper'
require 'rails_helper'

RSpec.configure do |c|
  c.include AuthHelper
  c.include FormHelper
end

RSpec.describe "Sub CRUD", type: :system do
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

    let!(:sub_posts) do
      posts = (1..3).to_a
      posts.map do |i|
        Post.create!(
          title: "post_#{i}",
          subs: [show_sub],
          author: i.even? ? main_user : other_user
        )
      end
    end
    
    context "when not logged in" do
      before(:each) { visit(sub_path(show_sub)) }
      
      it "shows the sub's title and description" do
        expect(page).to have_content(show_sub.title)
        expect(page).to have_content(show_sub.description)
      end

      it "shows an index of posts within the sub" do
        sub_posts.each do |post|
          expect(page).to have_content(post.title)
        end
      end
    end

    context "when logged in" do
      before(:each) do
        login(main_user)
        visit(sub_path(show_sub))
      end

      it "still shows the sub's title and description" do
        expect(page).to have_content(show_sub.title)
        expect(page).to have_content(show_sub.description)
      end

      it "shows an index of posts within the sub" do
        sub_posts.each do |post|
          expect(page).to have_content(post.title)
        end
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
          fill_in_form(valid_sub)
          click_button "CREATE"
          valid_sub.each_value do |sub_property|
            expect(page).to have_content(sub_property)
          end
        end
      end

      context "when the sub details are invalid" do
        it "refreshes the form with error messages" do
          fill_in_form(invalid_sub)
          click_button "CREATE"
          expect(page).to have_content("cannot contain spaces")
          expect(page).to have_content("Description can't be blank")
        end
      end
      
    end
  end

  describe "Sub Updates and Deletion" do
    let!(:update_sub) do
      Sub.create!(
        name: "UpdateSub",
        title: "Update This Sub...",
        description: "Only the mod can update this sub.",
        moderator: other_user
      )
    end
    context "when the user is not the sub moderator" do
      before(:each) { login(main_user) }
      it "doesn't provide an edit button on the sub page" do
        visit(sub_path(update_sub))
        expect(page).not_to have_link("EDIT", href: /#{edit_sub_path(update_sub)}$/)
      end

      it "doesn't permit access to the edit form via the url" do
        visit(edit_sub_path(update_sub))
        expect(page).not_to have_button("SAVE")
        expect(page).not_to have_current_path(edit_sub_path(update_sub))
      end
    end

    context "when the user is the sub moderator" do
      before(:each) do
        login(other_user)
        visit(sub_path(update_sub))
        click_link("EDIT")
      end

      it "allows the mod to update their sub from the sub page" do
        new_description = "Only other_user can update this sub."
        fill_in "sub_description", with: new_description
        click_button("SAVE")
        expect(page).to have_content(new_description)
        expect(page).to have_current_path(sub_path(update_sub))
      end

      it "allows the mod to delete the sub altogether" do
        click_button("DELETE")
        expect(page).to have_current_path(subs_path)
        expect(page).not_to have_content(update_sub.name)
        expect(page).to have_content("Sub Successfully Deleted")
      end
    end
  end
end