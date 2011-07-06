class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user, :current_user_session
  
  after_filter :store_last_good_page
  
  def store_last_good_page
    session[:last_good_page] = request.fullpath
  end
  
  def authorize
    if session[:user_session]
      logger.info("authorize - user_session found, cary on")
    else
      logger.info("authorize - no user_session found, force login")
      session[:return_to] = request.fullpath
      flash[:notice] = 'fuck off. you need to log in for that.'
      redirect_to(session[:last_good_page] || races_path)
    end
  end
  
  private
  
  def current_user
    @current_user_session ||= UserSession.find(session[:user_session]) if session[:user_session]
    @current_user ||= @current_user_session.user
  end
  
end
