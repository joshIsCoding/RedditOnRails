class SessionsController < ApplicationController
  skip_before_action :require_login, only: :new
  before_action :ensure_login, only: :destroy
  
  def new
  end

  def destroy
    logout!
    redirect_back(fallback_location: :root)
  end
end
