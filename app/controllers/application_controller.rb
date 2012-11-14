class ApplicationController < ActionController::Base
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user && FileManager.connected?
      if(current_user)
        redirect_to logout_path
      else
        redirect_to login_path
      end
      return false
    end
  end

  def require_no_user
    if current_user
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end
end