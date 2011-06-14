class AthletesController < ApplicationController
  
  before_filter :authorize, :only => :show
  
  # GET /athletes
  # GET /athletes.xml
  def index
    @athletes = Athlete.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @athletes }
    end
  end

  # GET /athletes/1
  # GET /athletes/1.xml
  def show
    # redirect to your own page if trying to view someone else's
    if session[:user_session].athlete_id.to_s != params[:id]
      redirect_to(athlete_path(session[:user_session].athlete_id))
      return
    end
    @athlete = Athlete.find(params[:id])
    @run_summaries = @athlete.run_summaries
    logger.info("@run_summaries: #{@run_summaries.inspect}")
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @athlete }
    end
  end

  # GET /athletes/new
  # GET /athletes/new.xml
  def new
    @athlete = Athlete.new
    @genders = Lookup.list_for('gender')

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @athlete }
      format.js { render :layout => false }
    end
  end

  # GET /athletes/1/edit
  def edit
    @athlete = Athlete.find(params[:id])
  end

  # POST /athletes
  def create
    params[:gender] = Lookup.find(params[:gender]) unless params[:gender].blank?
    @user = User.new({:first_name => params[:first_name], :user_name => params[:user_name], :last_name => params[:last_name], :born_on => params[:born_on], :password => params[:password], :authority => 1})
    @user.save
    @athlete = Athlete.new({:user_id => @user.id})
    
    if @athlete.save
      # sign in
      session[:user_session] = UserSession.create(:athlete => @athlete, :name => @user.user_name, :born_on => @user.born_on, :authority => @user.authority, :login_at => Time.now)
      redirect_to(@athlete)
    else
      render :action => "new"
    end
  end

  # PUT /athletes/1
  # PUT /athletes/1.xml
  def update
    @athlete = Athlete.find(params[:id])

    respond_to do |format|
      if @athlete.update_attributes(params[:athlete])
        format.html { redirect_to(@athlete, :notice => 'Athlete was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @athlete.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /athletes/1
  # DELETE /athletes/1.xml
  def destroy
    @athlete = Athlete.find(params[:id])
    @athlete.destroy

    respond_to do |format|
      format.html { redirect_to(athletes_url) }
      format.xml  { head :ok }
    end
  end
end
