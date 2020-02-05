class SubsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show, :update]
  before_action :ensure_user_is_mod, only: [:edit, :update, :destroy]
  def new
    @sub = Sub.new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator = current_user
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def show
    get_sub_from_params
    render :show if @sub
  end

  def index
    @subs = Sub.all ? Sub.all : []
  end

  def destroy
    if @sub.destroy
      flash[:notices] = ["Sub Successfully Deleted"]
      redirect_to subs_url
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :show
    end
  end

  private
  def sub_params
    params.require(:sub).permit(:name, :title, :description)
  end

  def get_sub_from_params
    @sub = Sub.find_by_id(params[:id])
    render_not_found unless @sub
  end

  def ensure_user_is_mod
    get_sub_from_params
    unless current_user == @sub.moderator
      redirect_back(fallback_location: sub_url(@sub))
    end
  end
end
