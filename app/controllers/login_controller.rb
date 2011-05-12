class LoginController < ApplicationController
    
  def index
    # show login screen
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def authenticate
    
    name = params[:person][:user_name]
    password = params[:person][:password]
    athlete = nil
    
    if APP_CONFIG['authenticate']
      logger.debug("LoginController.authenticate: authenticating...")
      user = User.find(:first, :params => { :user_name => name, :password => password }) unless name.blank? or password.blank?
      athlete = Athlete.find_by_user_id(user.id) unless user == nil
    else #not authenticating, just use adam as the user_name - debug only
      logger.debug("LoginController.authenticate: not authenticating just use adam...")
      athlete ||= Athlete.find_by_user_id(585460615)
    end

    if athlete
      logger.debug("LoginController.authenticate: user[#{athlete.inspect}]")
      session[:user] = athlete
      if session[:return_to]
        temp = session[:return_to]
        session[:return_to] = nil
        redirect_to(temp)
      else
        redirect_to athlete_path(athlete.id)
      end
    else
      flash[:notice] = 'Login failed!' 
      redirect_to races_path
    end
  end

  def logout
    reset_session
    flash[:notice] = 'Logged out' 
    redirect_to races_path 
  end
  
end
