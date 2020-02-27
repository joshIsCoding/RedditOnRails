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
    @comment = Comment.find_by_id(params[:id])
    flash[:errors] = @comment.errors.full_messages unless @comment.destroy
    redirect_back(fallback_location: @comment.post)
  end
end
