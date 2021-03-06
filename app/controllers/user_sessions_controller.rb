class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      # Retarded h4xx02 required by authlogic for some reason
      @user_session.user.reset_persistence_token!
      @user_session.save

      redirect_to root_url
    else
      render :action => :new
    end
  end

  def destroy
    FileManager.close

    current_user_session.destroy if current_user_session
    redirect_to login_url
  end
end
