class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authorize
    if session[:user]
      logger.info("authorize - found a session user: #{session[:user].inspect}")
      @user = Athlete.find(session[:user].id)
      @user.auth_profile = session[:user]
    else
      logger.info("authorize - no session user found, force login")
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
