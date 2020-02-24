class PostSubsController < ApplicationController
  def destroy
    @post_sub = PostSub.find_by_id(params[:id])
    unless @post_sub && (
      @post_sub.post.author == current_user || @post_sub.sub.moderator == current_user
    )
      redirect_back(fallback_location: subs_url) and return 
    end
    if @post_sub.post.post_subs.count == 1
      destroy_post(@post_sub.post)
    elsif @post_sub.destroy
      flash[:notices] = ["Post deleted from this sub."]
      redirect_to sub_url(@post_sub.sub)
    else
      redirect_back(fallback_location: sub_url(@post_sub.sub))
    end
  end
end
