class SessionsController < ApplicationController

  skip_after_filter :store_last_good_page

  # GET /sessions/new.js
  def new
  end

  # login
  # POST /sessions.js
  def create
    
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      user.session = Session.new(user_id: user.id) unless user.session
      user.session.login_at= Time.now
      user.session.logout_at= nil
      user.session.count= (user.session.count or 0) + 1
      user.session.save
      session[:user_session] = user.session.id

      go_to = session[:last_good_page] || user_path(user.to_param)
    else
      flash[:warning] = 'who are you talking about?'
      go_to = session[:last_good_page] || root_url
    end

    flash[:notice] = "logged in as #{user.name}"
    redirect_to go_to
  end

  # logout
  # DELETE /sessions/1
  # DELETE /sessions/1.js
  def destroy
    begin
      @session = Session.find(params[:id])
      @session.logout_at = Time.now
      @session.save
    rescue ActiveRecord::RecordNotFound
    end

    reset_session 
    redirect_to :root, notice: 'succesfully logged out.'
  end
end
