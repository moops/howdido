class RacesController < ApplicationController
  # GET /races
  # GET /races.xml
  def index
    @races = Race.page(params[:page]).per(2)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @races }
    end
  end

  # GET /races/1
  # GET /races/1.xml
  def show
    @race = Race.find(params[:id])
    @user_participations = current_user ? Athlete.find(current_user.athlete_id).participations : nil
    @results = @race.results.order(:overall_place).page(params[:page]).per(25)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @race }
    end
  end

  # GET /races/new
  # GET /races/new.xml
  def new
    @race = Race.new
    @race_types = Lookup.list_for('race_type')
    @distances = Lookup.list_for('race_dist')
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @race }
    end
  end

  # GET /races/1/edit
  def edit
    @race = Race.find(params[:id])
  end

  # POST /races
  # POST /races.xml
  def create
    h = params[:race]
    h['race_type'] = Lookup.find(h['race_type'].to_i)
    h['distance'] = Lookup.find(h['distance'].to_i)
    @race = Race.new(h)

    respond_to do |format|
      if @race.save
        format.html { redirect_to(@race, :notice => 'Race was successfully created.') }
        format.xml  { render :xml => @race, :status => :created, :location => @race }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @race.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /races/1
  # PUT /races/1.xml
  def update
    @race = Race.find(params[:id])

    respond_to do |format|
      if @race.update_attributes(params[:race])
        format.html { redirect_to(@race, :notice => 'Race was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @race.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /races/1
  # DELETE /races/1.xml
  def destroy
    @race = Race.find(params[:id])
    @race.destroy

    respond_to do |format|
      format.html { redirect_to(races_url) }
      format.xml  { head :ok }
    end
  end
end
