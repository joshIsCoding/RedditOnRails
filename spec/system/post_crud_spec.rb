require 'support/auth_helper'
require 'support/form_helper'
require 'rails_helper'

RSpec.configure do |c|
  c.include FormHelper
  c.include AuthHelper
end

RSpec.describe "Post CRUD", type: :system do
  let(:main_user) { User.create!(username: "Main User", password: "password") }
  let!(:main_sub) do
    Sub.create!(
        name: "Main",
        title: "Main", 
        description: "For talking about everything.",
        moderator: main_user
      )
  end

  describe "Post Creation" do
    
    context "when not logged in" do
      it "should not have a create post button" do
        visit(sub_path(main_sub))
        expect(page).not_to have_link(
          "CREATE POST", href: /#{new_sub_post_path(main_sub)}$/
        )
      end

      it "redirects to the login page if the create post url is visited" do
        visit(new_sub_post_path(main_sub))
        expect(page).not_to have_current_path(new_sub_post_path(main_sub))
        expect(page).not_to have_button("POST")
      end
    end

    context "when logged in" do
      let(:valid_post) do 
        { "post_title" => "New Post", "post_content" => "Great!"}
      end
      let(:invalid_post) do
        { "post_title" => "", "post_content" => "Great!"}
      end
      
      before(:each) do
        login(main_user)
        visit(sub_path(main_sub))
      end

      it "has a create post button" do
        expect(page).to have_link(
          "CREATE POST", href: /#{new_sub_post_path(main_sub)}$/
        )
      end

      it "lets a user create a post for the sub" do
        click_link("CREATE POST")
        fill_in_form(valid_post)
        click_button("POST")
        valid_post.each_value do |post_property|
          expect(page).to have_content(post_property)
        end
        expect(page).to have_current_path( /#{posts_path}\/\d+/)
      end

      it "refreshes the form with errors if the post details are invalid" do
        expect(page).to have_content("Title can't be blank")
        expect(page).to have_button("POST")
      end
    end
  end

end