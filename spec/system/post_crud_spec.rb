require 'support/auth_helper'
require 'support/form_helper'
require 'rails_helper'

RSpec.configure do |c|
  c.include FormHelper
  c.include AuthHelper
end

RSpec.describe "Post CRUD", type: :system do
  let(:main_user) { User.create!(username: "Main User", password: "password") }
  let(:other_user) { User.create!(username: "Other User", password: "password") }
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
        click_on("CREATE POST")
        fill_in_form(valid_post)
        click_button("POST")
        valid_post.each_value do |post_property|
          expect(page).to have_content(post_property)
        end
        expect(page).to have_current_path( /#{posts_path}\/\d+/)
      end

      it "allows a user to select multiple subs when creating posts" do
        other_sub = Sub.create!(
          name: "Other",
          title: "Other", 
          description: "For talking about everything else.",
          moderator: other_user
        )
        click_on("CREATE POST")
        fill_in_form(valid_post)
        check("Other")
        click_button("POST")
        visit(sub_path(other_sub))
        expect(page).to have_content(valid_post["post_title"])
        visit(sub_path(main_sub))
        expect(page).to have_content(valid_post["post_title"])
      end

      it "refreshes the form with errors if the post details are invalid" do
        click_on("CREATE POST")
        fill_in_form(invalid_post)
        click_button("POST")
        expect(page).to have_content("Title can't be blank")
        expect(page).to have_button("POST")
      end
    end
  end

  let!(:main_post) do 
    Post.create!(
      title: "Main Post",
      content: "User's Post",
      subs: [main_sub],
      author: main_user
    )
  end

  let(:other_post) do
    Post.create!(title: "other_post", subs: [main_sub], author: other_user)
  end

  describe "Post Updates" do

    context "when not logged in" do
      it "doesn't provide an edit button from the sub or post pages" do
        visit(sub_path(main_sub))
        expect(find("section.posts")).not_to have_link(
          "Edit Post", 
          href: /#{edit_post_path(main_post)}$/
        )

        visit(post_path(main_post))
        expect(page).not_to have_link(
          "Edit Post", 
          href: /#{edit_post_path(main_post)}$/
        )
      end

      it "doesn't permit access to the edit form via the url" do
        visit(edit_post_path(main_post))
        expect(page).to have_current_path(login_path)
      end
    end

    context "when the user is logged in" do

      before(:each) { login(main_user) }
      
      it "provides edit buttons for the user's own posts" do
        visit(sub_path(main_sub))
        expect(find("section.posts")).to have_link(
          "Edit Post", 
          href: /#{edit_post_path(main_post)}$/
        )

        visit(post_path(main_post))
        expect(page).to have_link(
          "Edit Post", 
          href: /#{edit_post_path(main_post)}$/
        )
      end

      it "doesn't provide an edit button for other users' posts" do
        other_post.valid?
        visit(sub_path(main_sub))
        expect(page).
        not_to have_link("Edit Post", href: /#{edit_post_path(other_post)}$/)
      end
      
      it "permits editing of the user's own posts" do
        visit(edit_post_path(main_post))
        fill_in "post_title", with: "Edited Post"
        click_button "SAVE"
        expect(page).to have_content("Edited Post")
        expect(page).to have_current_path(post_path(main_post))
      end

      it "doesn't let a user edit other users' posts via the url" do
        other_post.valid?
        visit(edit_post_path(other_post))
        expect(page).to have_current_path(post_path(other_post))
        expect(page).
        not_to have_link("Edit Post", href: /#{edit_post_path(other_post)}$/)
      end
    end
  end

  describe "Post Deletion" do
    context "when not logged in" do
      it "doesn't allow the user to delete posts from the sub or post pages" do
        visit(sub_path(main_sub))
        expect(find("section.posts")).not_to have_button("Delete Post")

        visit(post_path(main_post))
        expect(page).not_to have_button("Delete Post")
      end
    end

    context "when logged in" do
      let!(:other_sub) do 
        Sub.create!(
          name: "Other",
          title: "Other", 
          description: "For talking about everything else.",
          moderator: other_user
        )
      end
      
      before(:each) { login(main_user)}
      it "allows the user to delete all posts for subs in which they are the mod" do
        other_post.valid?
        visit(sub_path(main_sub))
        expect(page).to have_button("Delete Post", count: 2)          
        click_button("Delete Post", match: :first)
        expect(page).to have_current_path(sub_path(main_sub))
        click_button("Delete Post")
        expect(page).not_to have_content(other_post.title)
      end

      it "allows the user to delete their own posts in other subs" do
        other_sub_post = Post.create!(
          title: "Other's Post",
          subs: [other_sub],
          author: other_user
        )

        other_sub_main_post = Post.create!(
          title: "Main's Post",
          subs: [other_sub],
          author: main_user
        )

        visit(sub_path(other_sub))
        expect(page).to have_button("Delete Post", count: 1)
        click_button("Delete Post")
        expect(page).not_to have_content(other_sub_main_post.title)
      end

      context "when a post is listed under multiple subs" do
        let!(:multi_sub_post) do 
          Post.create!(
            title: "Main's Multi-sub Post",
            subs: [main_sub, other_sub],
            author: main_user
          )
        end

        it "doesn't delete the whole post if deleted at the sub level" do
          visit(sub_path(main_sub))
          click_button("Delete Post", match: :first)
          expect(page).to have_current_path(sub_path(main_sub))
          expect(page).to have_content("Post deleted from this sub.")
          expect(page).not_to have_content(multi_sub_post.title)
          visit(sub_path(other_sub))
          expect(page).to have_content(multi_sub_post.title)
        end

        it "deletes the post in all contexts if deleted at the post level" do
          visit(post_path(multi_sub_post))
          click_button("Delete Post")
          [main_sub, other_sub].each do |sub|
            visit(sub_path(sub))
            expect(page).not_to have_content(multi_sub_post.title)
          end
        end
      end
    end
  end

end