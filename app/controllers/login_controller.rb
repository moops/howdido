class LoginController < ApplicationController
    
  def index
    # show login screen
  end

  def authenticate
    
    if APP_CONFIG['authenticate']
      logger.debug("LoginController.authenticate: authenticating...")
      auth_profile = Person.authenticate(params[:person][:user_name], params[:person][:password])
    else #not authenticating, just use the param as the user_name
      logger.debug("LoginController.authenticate: not authenticating just use user_name param...")
      user = Athlete.find_by_user_name(params[:person][:user_name])
      auth_profile = AuthProfile.new(user.id, params[:person][:user_name], 1, Date.parse('1970-01-01')) if user.id
    end

    if auth_profile
      logger.debug("LoginController.authenticate: auth profile[#{auth_profile.inspect}]")
      session[:user] = auth_profile
      if session[:return_to]
        temp = session[:return_to]
        session[:return_to] = nil
        redirect_to(temp)
      else
        redirect_to links_path
      end
    else
      flash[:notice] = 'Login failed!' 
      redirect_to :action => 'index'
    end
  end

  def logout
    reset_session
    flash[:notice] = 'Logged out' 
    redirect_to :action => 'index' 
  end
  
end
