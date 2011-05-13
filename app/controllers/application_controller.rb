class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authorize
    unless session[:user_session]
      logger.info("authorize - no user_session found, force login")
      #session[:return_to] = request.request_uri
      #redirect_to :controller => 'login'
      respond_to do |format|
        format.html {logger.info('why you html?')}
        format.js { 
          logger.info('calling login index as js')
          render('login/index', :layout => false) }
      end
      logger.info('never get here do you?')
      return false
    end
  end
  
end
