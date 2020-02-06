class PostsController < ApplicationController
  def show
    @post = Post.find_by_id(params[:id])
  end

  def new
    @post = Post.new
    @post.sub = Sub.find_by_id(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user
    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :sub_id)
  end
end
