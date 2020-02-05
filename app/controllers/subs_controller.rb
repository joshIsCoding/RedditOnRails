class SubsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
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
  end

  def show
    @sub = Sub.find_by_id(params[:id])
  end

  def index
    @subs = Sub.all ? Sub.all : []
  end

  def destroy
  end

  private
  def sub_params
    params.require(:sub).permit(:name, :title, :description)
  end
end
