class UsersController < ApplicationController
  
  before_filter :authorize, :only => :show
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    # redirect to your own page if trying to view someone else's
    if session[:user_session].user_id.to_s != params[:id]
      redirect_to(user_path(session[:user_session].user_id))
      return
    end
    @user = User.find(params[:id])
    @run_summaries = @user.run_summaries
    logger.info("@run_summaries: #{@run_summaries.inspect}")
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
      format.js { render :layout => false }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    # params[:user][:gender] = Lookup.find(params[:user][:gender]) unless params[:user][:gender].blank?
    @user = User.new(params[:user])
    @user.authority= 1
    
    if @user.save
      logger.debug("signing in...")
      # sign in
      session[:user_session] = UserSession.create(:user_id => @user.id, :login_at => Time.now)
      redirect_to(@user)
    else
      logger.debug("WTF: #{@user.inspect}")
      render "new"
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
