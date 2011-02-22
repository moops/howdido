class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authorize
    if session[:user]
      @user = Athlete.find(session[:user].user_id)
      @user.auth_profile = session[:user]
    else
      session[:return_to] = request.request_uri
      redirect_to :controller => 'login' 
      return false
    end
  end
  
end
