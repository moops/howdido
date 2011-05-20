class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authorize
    if session[:user_session]
      logger.info("authorize - user_session found, cary on")
      return true
    else session[:user_session]
      logger.info("authorize - no user_session found, force login")
      session[:return_to] = request.fullpath
      #redirect_to :controller => 'login'
      respond_to do |format|
        format.html {
          logger.info('why you html?')
          render('user_sessions/new.js', :layout => false)
        }
        format.js { 
          logger.info('calling login index as js')
          render('user_sessions/new.js', :layout => false)
        }
      end
      return false
    end
  end
  
end
