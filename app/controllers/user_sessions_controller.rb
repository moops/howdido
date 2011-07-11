class UserSessionsController < ApplicationController
  
  skip_after_filter :store_last_good_page

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
    else
      flash[:notice] = 'who are you talking about?'
    end
    
    # where do we go after login?
    session[:return_to] = user_path(user.id) unless session[:return_to]
    redirect_to(session[:return_to])
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
    redirect_to :root
  end
end
