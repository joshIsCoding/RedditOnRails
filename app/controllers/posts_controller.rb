class PostsController < ApplicationController
  before_action :ensure_user_is_author, only: [:edit, :update]
  before_action :ensure_user_has_authority, only: :destroy
  skip_before_action :require_login, only: :show
  def show
    get_post_from_params
  end

  def new
    @post = Post.new
    @post.sub_ids = [params[:sub_id]]
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
    destroy_post(@post)
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, sub_ids:[])
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

  def ensure_user_has_authority
    get_post_from_params
    unless current_user == @post.author || (
      @post.subs.count == 1 && current_user == @post.subs.first.moderator
    )
      redirect_back(fallback_location: post_url(@post))
    end
  end


end
