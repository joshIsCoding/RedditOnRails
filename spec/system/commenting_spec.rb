require 'support/auth_helper'
require 'rails_helper'

RSpec.configure do |c|
  c.include AuthHelper
end

RSpec.describe "Creating and Deleting Comments", type: :system do
  let(:main_user) { User.create!(username: "main_user", password: "password") }
  let!(:main_sub) do
    Sub.create!(
        name: "Main",
        title: "Main", 
        description: "For talking about everything.",
        moderator: main_user
      )
  end
  let!(:main_post) do 
    Post.create!(
      title: "Main Post",
      content: "User's Post",
      subs: [main_sub],
      author: main_user
    )
  end

  describe "Creating Comments" do
    context "when user isn't logged in" do
      let!(:prior_comment) do 
        Comment.create!(
          contents: "previous comment",
          post: main_post,
          author: main_user        
        )
      end
      before(:each) { visit(post_path(main_post)) }
      it "shows prior comments" do
        expect(page).to have_content(prior_comment.contents)        
      end

      it "doesn't let allow them to add comments" do
        expect(page).not_to have_content("Comment as")
        expect(page).not_to have_selector("form.add-comment")
        expect(page).not_to have_button("Comment")
      end
    end

    context "when user is logged in" do
      before(:each) do
        login(main_user)
        visit(post_path(main_post))
      end
      it "provides a comment form for posts" do
        expect(page).to have_content("Comment as #{main_user.username}")
        expect(page).to have_selector("form.add-comment")
        expect(page).to have_button("Comment")
      end

      it "doesn't permit blank comments" do
        click_on("Comment")
        expect(page).to have_content("Contents cannot be blank")
        expect(find("section.comments")).not_to have_content(main_user.username)
      end
    end
  end

  describe "Comment Deletion" do
    context "when not logged in" do
      it "doesn't allow a user to delete any comments"
    end

    context "when logged in" do
      it "allows a user to delete their own comments"
      it "does not allow a user to delete other user's comments"

      it "allows moderators of a sub to delete comments on posts linked to their sub"
    end

  end
end