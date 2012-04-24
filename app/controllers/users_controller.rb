class UsersController < ApplicationController

  load_and_authorize_resource

  # GET /users/1
  # GET /users/1.xml
  def show
  
    @user = @user = current_user
    @run_summaries = @user.run_summaries
    
    respond_to do |format|
      format.html {
        if @user.participations.any?
          # show.html.erb
        else
          redirect_to(:root, :notice => 'you have no participations')
        end
      }
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
      format.js { render :layout => false }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    
    @user.roles=(['athlete'])
    
    logger.info('###saving###')
    logger.info("#{@user.inspect}")
    if @user.save
      logger.info('###saved###')
      # sign in
      @user.session= UserSession.create(:user_id => @user.id, :login_at => Time.now, :logout_at => nil, :count => 1)
      session[:user_session] = @user.session.id
      redirect_to(@user)
    else
      msg = ''
      if @user.errors.any?  
        @user.errors.full_messages.each do |m|
          msg = msg << m
        end
      end
      redirect_to(:root, :notice => 'user creation failed because: ' << msg)
    end
  end

end
