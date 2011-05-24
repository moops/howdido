class UserSessionsController < ApplicationController
  
  skip_after_filter :store_last_good_page

  # GET /user_sessions/new
  # GET /user_sessions/new.js
  def new
    respond_to do |format|
      format.js  { render :layout => false }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.js
  def create
    
    if params[:user_name].blank? or params[:password].blank?
      logger.info('something is blank')
    else
      logger.info('found everything we need')
      user = User.find(:first, :params => { :user_name => params[:user_name], :password => params[:password] })
      logger.info("user_hash: #{user.inspect}")
    end
    
    athlete = Athlete.find_by_user_id(user.id) unless user == nil
    logger.info("found: #{athlete.inspect}")

    if athlete
      logger.info("2found: #{athlete.inspect}")
      session[:user_session] = UserSession.create(:athlete => athlete, :name => user.user_name, :born_on => user.born_on, :authority => user.authority, :login_at => Time.now)
      # where do we go after login?
      session[:return_to] = athlete_path(athlete.id) unless session[:return_to]
      # redirect_to(session[:return_to])
    else
      logger.info('found NO user')
      flash[:notice] = 'Login failed!' 
      redirect_to(session[:last_good_page] || races_path)
    end
  end
  
  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.js
  def destroy
    @session = UserSession.find(params[:id])
    @session.logout_at = Time.now
    @session.save
    
    reset_session 
    redirect_to races_path 
  end
end
