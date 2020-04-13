class CommentsController < ApplicationController
  before_action :find_and_authenticate_comment, only: :destroy
  before_action :find_comment, except: [:create, :destroy]
  
  def show
    redirect_back(fallback_location: root_url) and return unless @comment
  end

  def create
    @comment = Comment.new(
      params.require(:comment).permit(:contents, :post_id, :parent_comment_id)
    )
    @comment.author = current_user
    if @comment.save
      redirect_to @comment.post, anchor: @comment.id
    else
      flash[:errors] = @comment.errors.full_messages
      fallback = @comment.post ? @comment.post : subs_url
      redirect_back(fallback_location: fallback)
    end
  end

  def destroy
    flash[:errors] = @comment.errors.full_messages unless @comment.destroy
    redirect_back(fallback_location: @comment.post)
  end

  def upvote
    vote(:up, @comment)
  end

  def downvote
    vote(:down, @comment)
  end

  private

  def find_comment
    @comment = Comment.find_by_id(params[:id])
  end

  def find_and_authenticate_comment
    find_comment
    unless ( @comment.author == current_user || 
      @comment.post.sub_mods.include?(current_user) 
    )
      redirect_back(fallback_location: @comment.post)
    end
  end
end
