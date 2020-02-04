class SubsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
    @sub = Sub.find_by_id(params[:id])
  end

  def index
  end

  def destroy
  end
end
