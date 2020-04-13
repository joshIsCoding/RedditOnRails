class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login_user!(user)
    @current_user = user
    session[:session_token] = user.reset_session_token!
    nil
  end

  def logged_in?
    !current_user.nil?
  end

  def logout!
    @current_user.reset_session_token!
    session[:session_token] = nil
    @current_user = nil
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

  def destroy_post(post)
    sub = post.subs.first
    if post.destroy
      flash[:notices] = ["Post successfully deleted for all subs."]
      redirect_to sub_url(sub)
    else
      redirect_back(fallback_location: post_url(post))
    end
  end

  def vote(type, resource)
    unless resource.vote(type, current_user)
      flash[:errors] = ["Vote not registered."]
    end
    redirect_back( fallback_location: resource )
  end

  def render_not_found
      raise ActionController::RoutingError.new('Page not found')
   end
end
