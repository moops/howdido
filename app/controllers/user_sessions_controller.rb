class UserSessionsController < ApplicationController
  
  skip_after_filter :store_last_good_page

  # login
  # POST /user_sessions.js
  def create
    
    unless params[:user_name].blank? or params[:password].blank?
      user = User.find(:first, :params => { :user_name => params[:user_name], :password => params[:password] })
    end
    
    athlete = Athlete.find_by_user_id(user.id) unless user == nil

    if athlete
      session[:user_session] = UserSession.create(:athlete => athlete, :name => user.user_name, :born_on => user.born_on, :authority => user.authority, :login_at => Time.now)
      # where do we go after login?
      session[:return_to] = athlete_path(athlete.id) unless session[:return_to]
      render :login
    else
      flash[:notice] = 'who are you talking about?'
      render :login_fail
    end
  end
  
  # logout
  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.js
  def destroy
    @session = UserSession.find(params[:id])
    @session.logout_at = Time.now
    @session.save
    
    reset_session 
    render :logout
    # redirect_to races_path 
  end
end
