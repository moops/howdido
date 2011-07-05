class UserSessionsController < ApplicationController
  
  skip_after_filter :store_last_good_page

  # login
  # POST /user_sessions.js
  def create
    
    user = User.authenticate(params[:email], params[:password])

    if user
      session[:user_id] = user.id
      session[:user_session] = UserSession.create(:user_id => user.id, :login_at => Time.now)
      # where do we go after login?
      session[:return_to] = user_path(user.id) unless session[:return_to]
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
    begin
      @session = UserSession.find(params[:id])
      @session.logout_at = Time.now
      @session.save
    rescue ActiveRecord::RecordNotFound
    end
    
    reset_session 
    render :logout
  end
end
