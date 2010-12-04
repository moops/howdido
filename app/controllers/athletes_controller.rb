class AthletesController < ApplicationController
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
    @athlete = Athlete.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @athlete }
    end
  end

  # GET /athletes/new
  # GET /athletes/new.xml
  def new
    @athlete = Athlete.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @athlete }
    end
  end

  # GET /athletes/1/edit
  def edit
    @athlete = Athlete.find(params[:id])
  end

  # POST /athletes
  # POST /athletes.xml
  def create
    @athlete = Athlete.new(params[:athlete])

    respond_to do |format|
      if @athlete.save
        format.html { redirect_to(@athlete, :notice => 'Athlete was successfully created.') }
        format.xml  { render :xml => @athlete, :status => :created, :location => @athlete }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @athlete.errors, :status => :unprocessable_entity }
      end
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
