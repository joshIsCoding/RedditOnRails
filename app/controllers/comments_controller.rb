class CommentsController < ApplicationController
  def create
    @comment = Comment.new(params.require(:comment).permit(:contents, :post_id))
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
  end
end
