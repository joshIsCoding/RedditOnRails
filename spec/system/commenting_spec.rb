require 'support/auth_helper'
require 'rails_helper'

RSpec.configure do |c|
  c.include AuthHelper
end

RSpec.describe "Creating and Deleting Comments", type: :system do
  let(:main_user) { User.create!(username: "main_user", password: "password") }
  let(:other_user) { User.create!(username: "other_user", password: "password")}

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
  let!(:prior_comment) do 
    Comment.create!(
      contents: "previous comment",
      post: main_post,
      author: main_user        
    )
  end

  describe "Creating Comments" do
    context "when user isn't logged in" do
      
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
        expect(page).to have_content("Contents can't be blank")
        expect(find("section.comments")).
        to have_content(main_user.username, count: 1)
        # prior comment will be present and was also authored by main_user;
        # main_user's name should thus appear once only in the comments section.
      end
    end
  end

  describe "Comment Deletion" do
    context "when not logged in" do
      it "doesn't allow a user to delete any comments" do
        visit(post_path(main_post))
        expect(page).not_to have_button("Delete Comment")
      end
    end

    context "when logged in" do
      before(:each) do
        login(main_user)
      end
      it "allows a user to delete their own comments" do
        visit(post_path(main_post))
        find("article.comment footer").click_on("Delete Comment")
        expect(page).to have_current_path(post_path(main_post))
        expect(page).not_to have_content(prior_comment.contents)        
      end

      
      
      it "does not allow a user to delete other user's comments" do
        other_sub = Sub.create!(
          moderator: other_user,
          name: "Other",
          title: "Other", 
          description: "For talking about other things.",
        )
        other_post = Post.create!(
          title: "Other post",
          content: "Other sub post",
          subs: [other_sub],
          author: main_user
        )
        other_post_comment = Comment.create!(
          post: other_post,
          author: other_user,
          contents: "main user cannot delete me"
        )
        visit(post_path(other_post))
        expect(page).to have_content(other_post_comment.contents)
        expect(page).not_to have_button("Delete Comment")
      end

      it "allows moderators of a sub to delete comments on posts linked to their sub" do
        other_user_comment = Comment.create!(
          post: main_post,
          author: other_user,
          contents: "Sub moderator can delete me"
        )

        visit(post_path(main_post))
        expect(page).to have_content(other_user_comment.contents)
        find("article.comment footer", match: :first).click_on("Delete Comment")
        expect(page).to have_current_path(post_path(main_post))
        expect(page).not_to have_content(other_user_comment.contents)
      end
    end

  end

  describe "Nested Comments" do
    describe "Nest Comment Display" do
      let!(:level_1_nested_comments) do
        [Comment.create!(
            contents: "first nested comment",
            parent_comment: prior_comment,
            post: main_post,
            author: other_user        
          ),
          Comment.create!(
            contents: "second nested comment",
            parent_comment: prior_comment,
            post: main_post,
            author: main_user        
          )
        ]
      end
        
      it "shows 1st level nested comments in the right place" do
        visit(post_path(main_post))
        level_1_nested_comments.each do |nested_comment|
          expect(page).to have_content(nested_comment.contents, count: 1)
        end
        expect(page).to have_selector("section.comments ul.level-1 > li", count: 2)
        # nest comments should not be rendered in top-level list through general
        # :comments association
        expect(page).to have_selector("section.comments ul.top-level > li", count: 1)
      end
      let!(:level_2_nested_comment) do
        Comment.create!(
          contents: "level-2 nested comment",
          parent_comment: level_1_nested_comments.last,
          post: main_post,
          author: other_user        
        )
      end
      it "shows 2nd level nested comments" do   
        visit(post_path(main_post))
        expect(page).to have_content(level_2_nested_comment.contents, count: 1)
        expect(page).
        to have_selector("section.comments ul.level-1 ul.level-2 li", count: 1)
      end
    end
  end
end