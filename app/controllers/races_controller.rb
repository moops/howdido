class RacesController < ApplicationController
  
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction
  
  # GET /races
  # GET /races.xml
  def index
    @races = Race.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(10)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @races }
    end
  end

  # GET /races/1
  # GET /races/1.xml
  def show
    @user_participations = current_user ? current_user.participations : nil
    @results = @race.results.order(results_sort_column + " " + results_sort_direction).page(params[:page]).per(25)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @race }
      format.js
    end
  end

  # GET /races/new
  # GET /races/new.xml
  def new
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @race }
    end
  end

  # GET /races/1/edit
  def edit
  end

  # POST /races
  # POST /races.xml
  def create
    
    if (params[:race][:distance] == 'other')
      @race.distance= params[:other_distance].to_f
      @race.distance_unit= params[:other_distance_unit]
    elsif params[:race][:distance].end_with?('m')
      @race.distance= params[:race][:distance].chop!.to_f
      @race.distance_unit= 'mi'
    else
      @race.distance= params[:race][:distance].to_f
      @race.distance_unit= 'km'
    end

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
  
    if (params[:race][:distance] == 'other')
      @race.distance= params[:other_distance].to_f
      @race.distance_unit= params[:other_distance_unit]
    elsif params[:race][:distance].end_with?('m')
      @race.distance= params[:race][:distance].chop!.to_f
      @race.distance_unit= 'mi'
    else
      @race.distance= params[:race][:distance].to_f
      @race.distance_unit= 'km'
    end

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
    @race.destroy

    respond_to do |format|
      format.html { redirect_to(races_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  # used in index action to sort races list
  def sort_column
    Race.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  # used in show action to sort results list
  def results_sort_column
    Result.column_names.include?(params[:sort]) ? params[:sort] : "overall_place"
  end
  
  def results_sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
