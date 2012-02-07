class UserSessionsController < ApplicationController
  
  skip_after_filter :store_last_good_page
  
  # GET /user_sessions/new
  def new
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  # login
  # POST /user_sessions.js
  def create
    
    user = User.authenticate(params[:email], params[:password])

    if user
      user.session= UserSession.new(:user_id => user.id) unless user.session
      user.session.login_at= Time.now
      user.session.logout_at= nil
      user.session.count= (user.session.count or 0) + 1
      user.session.save
      session[:user_session] = user.session.id
      
      go_to = session[:last_good_page] || user_path(user.to_param)
    else
      flash[:notice] = 'who are you talking about?'
      go_to = session[:last_good_page] || root_url
    end
    
    redirect_to go_to
  end
  
  # logout
  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.js
  def destroy
    begin
      @user_session = UserSession.find(params[:id])
      @user_session.logout_at = Time.now
      @user_session.save
    rescue ActiveRecord::RecordNotFound
    end
    
    reset_session 
    redirect_to :root, :notice => "succesfully logged out."
  end
end
