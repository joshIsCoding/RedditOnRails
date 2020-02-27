class CommentsController < ApplicationController
  before_action :find_and_authenticate_comment, only: :destroy
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
    flash[:errors] = @comment.errors.full_messages unless @comment.destroy
    redirect_back(fallback_location: @comment.post)
  end

  private
  def find_and_authenticate_comment
    @comment = Comment.find_by_id(params[:id])
    unless ( @comment.author == current_user || 
      @comment.post.sub_mods.include?(current_user) 
    )
      redirect_back(fallback_location: @comment.post)
    end
  end
end
