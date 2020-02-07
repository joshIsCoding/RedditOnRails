class PostsController < ApplicationController
  before_action :ensure_user_is_author, only: [:edit, :update, :destroy]
  def show
    get_post_from_params
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
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def destroy
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :sub_id)
  end

  def get_post_from_params
    @post = Post.find_by_id(params[:id])
    render_not_found unless @post
  end

  def ensure_user_is_author
    get_post_from_params
    unless current_user == @post.author
      redirect_back(fallback_location: post_url(@post))
    end
  end

end
