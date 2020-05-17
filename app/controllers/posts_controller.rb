class PostsController < ApplicationController
  skip_before_action :require_login, only: :show
  before_action :find_post, except: [:new, :create]
  before_action :ensure_user_is_author, only: [:edit, :update]
  before_action :ensure_user_has_authority, only: :destroy
  
  def show
    @comments = @post.comments_by_parent_id
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

  def upvote
    vote :up, @post
  end

  def downvote
    vote :down, @post
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, sub_ids:[])
  end

  def find_post
    @post = Post.find_by_id(params[:id])
    render_not_found unless @post
  end

  def ensure_user_is_author
    unless current_user == @post.author
      redirect_back(fallback_location: post_url(@post))
    end
  end

  def ensure_user_has_authority
    unless current_user == @post.author || (
      @post.subs.count == 1 && current_user == @post.subs.first.moderator
    )
      redirect_back(fallback_location: post_url(@post))
    end
  end


end
