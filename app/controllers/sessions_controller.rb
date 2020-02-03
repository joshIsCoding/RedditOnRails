class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :ensure_login, only: :destroy

  def new
  end

  def create
    @user = User.find_by_credentials(
      session_params[:username], 
      session_params[:password]
    )
    if @user
      login_user!(@user)
      redirect_to :root
    else
      flash.now[:errors] = ["Invalid credentials"]
      render :new
    end
  end

  def destroy
    logout!
    redirect_back(fallback_location: :root)
  end

  private
  def session_params
    params.require(:user)
  end
end
