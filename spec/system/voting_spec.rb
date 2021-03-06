require 'support/auth_helper'
require 'rails_helper'

RSpec.configure do |c|
  c.include AuthHelper
end

RSpec.describe "Voting", type: :system do
  let( :main_user ) { create :user }
  
  describe "Voting on Posts" do
    let!( :sub ) { create :sub_with_posts, posts_count: 3 }
    let!( :upvotes ) do
      create_list( :vote, 3, :for_post, votable: sub.posts.last)
    end

    context "if the user isn't logged in" do
      before { visit( sub_path( sub )) }

      it "shows the vote counts for posts" do
        expect( find("article.post .votes-widget data", match: :first) ).to have_content( upvotes.count )
      end

      it "redirects the user to the login page if they try to cast a vote" do
        find( "article.post .votes-widget a.upvote", match: :first ).click
        expect( page ).to have_current_path( login_path )
      end
    end
    context "when the user is logged in" do
      before do
        login( main_user )
        visit( sub_path( sub ))
      end

      it "shows the vote counts for posts" do
        expect( find( "article.post .votes-widget data", match: :first )).to have_content( upvotes.count )
      end

      it "lets the user upvote posts" do
        find( "article.post .votes-widget a.upvote", match: :first ).click
        expect( find("article.post .votes-widget data", match: :first) ).to have_content( upvotes.count + 1 )
        all("article.post .votes-widget a.upvote").last.click
        expect( all("article.post .votes-widget data")[1] ).to have_content( 1 )
      end
      
      it "lets the user downvote posts" do
        find( "article.post .votes-widget a.downvote", match: :first ).click
        expect( find("article.post .votes-widget data", match: :first) ).to have_content( upvotes.count - 1 )
        all("article.post .votes-widget a.downvote").last.click
        expect( all("article.post .votes-widget data").last ).to have_content( -1 )
      end
      
      it "doesn't allow a user to upvote a post more than once" do
        find( "article.post .votes-widget a.upvote", match: :first ).click
        expect( find( "article.post .votes-widget", match: :first) ).not_to have_selector( "a.upvote")
      end

      it "doesn't allow a user to downvote a post more than once" do
        find( "article.post .votes-widget a.downvote", match: :first ).click
        expect( find( "article.post .votes-widget ", match: :first) ).not_to have_selector( "a.downvote")
      end

      it "doesn't let the user vote for their own posts" do
        user_post = create( :post, author: main_user )
        visit post_path( user_post )
        expect( find( 'aside.votes-widget' ) ).to have_content( '0' )
        expect( find( 'aside.votes-widget' ) ).not_to have_selector( 'a.upvote')
        expect( find( 'aside.votes-widget ' ) ).not_to have_selector( 'a.downvote')
      end
    end
  end

  describe 'Voting on Comments' do
    let!( :post ) { create :post }
    let!( :comments ) { create_list :comment, 3, post: post }
    let!( :upvotes ) do
      create_list( :vote, 3, :for_comment, votable: comments.last )
    end

    context 'When user is not logged in' do
      before { visit post_path post }
      it 'shows the total votes count above each comment' do
        expect( find( 'article.comment data.votes', match: :first )).to have_content('3 votes')
      end

      it 'redirects to login page if the user tries to cast a vote' do
        find( 'article.comment aside.votes-widget a.upvote', match: :first ).click
        expect( page ).to have_current_path( login_path )
      end
    end

    context 'When user is logged in' do
      before do 
        login main_user
        visit post_path post
      end

      it 'shows the total votes count above each comment' do
        expect( find( 'article.comment data.votes', match: :first )).to have_content('3 votes')
      end

      it 'allows the user to upvote comments for a maximum of once each' do
        find( 'article.comment aside.votes-widget a.upvote', match: :first ).click
        expect( find( 'article.comment data.votes', match: :first ) ).to have_content('4 votes')
        all( 'article.comment aside.votes-widget a.upvote' ).last.click
        expect( all( 'article.comment data.votes' ).last ).to have_content('1 vote')
      end

      it 'allows the user to downvote comments for a maximum of once each' do
        find( 'article.comment aside.votes-widget a.downvote', match: :first ).click
        expect( find( 'article.comment data.votes', match: :first )).to have_content('2 votes')
        all( 'article.comment aside.votes-widget a.downvote' )[1].click
        expect( all( 'article.comment data.votes' )[2] ).to have_content('-1 vote')
      end

      it 'does not let the user vote for their own comments' do
        user_comment = create( :comment, author: main_user )
        visit post_path( user_comment.post )
        expect( find( 'article.comment data.votes' )).to have_content('0 votes')
        expect( page ).not_to have_selector( 'article.comment aside.votes-widget a.upvote' )
        expect( page ).not_to have_selector( 'article.comment aside.votes-widget a.downvote' )
      end
    end
  end

end