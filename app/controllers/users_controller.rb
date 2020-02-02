class UsersController < ApplicationController
  skip_before_action :require_login
  before_action :already_logged_in
  def new
  end

  def create
    @new_user = User.new(user_params)
    if @new_user.save
      login_user!(@new_user)
      redirect_to :root
    else
      flash.now[:errors] = @new_user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
