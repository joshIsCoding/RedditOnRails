class ApplicationController < ActionController::Base
  before_action :require_login

  helper_method :current_user, :logged_in?
  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login_user!(user)
    @current_user = user
    session[:session_token] = user.reset_session_token!
  end

  def logged_in?
    !current_user.nil?
  end

  def logout!(user)
  end

  def require_login
    unless logged_in?
      flash[:errors] = ["You can only do that with a RedditOnRails account."]
      redirect_to login_url 
    end
  end

  def already_logged_in
    redirect_to :root if logged_in?
  end
end
