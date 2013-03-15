class RacesController < ApplicationController

  load_and_authorize_resource
  helper_method :sort_column, :sort_direction

  # GET /races
  def index
    @races = Race.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page]).per(10)
  end

  # GET /races/1
  # GET /races/1.js
  def show
    @user_participations = current_user ? current_user.participations : nil
    @results = @race.results.order(results_sort_column + " " + results_sort_direction).page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /races/new.js
  def new
    @race_types = Lookup.list_for('race_type')
    @race_distances = Lookup.list_for('race_dist')
  end

  # GET /races/1/edit.js
  def edit
    @race_types = Lookup.list_for('race_type')
    @race_distances = Lookup.list_for('race_dist')
  end

  # POST /races
  def create
    set_distance(params, @race)

    if @race.save
      redirect_to(@race, notice: 'Race was successfully created.')
    else
      render action: 'new'
    end
  end

  # PUT /races/1
  def update
    set_distance(params, @race)
    params[:race].delete('distance')
    if @race.update_attributes(params[:race])
      format.html redirect_to(@race, notice: 'Race was successfully updated.')
    else
      format.html render action: 'edit'
    end
  end

  # DELETE /races/1
  def destroy
    @race.destroy
    redirect_to races_path
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

  def set_distance(params, race)
    if (params[:race][:distance] == 'other')
      race.distance= params[:other_distance].to_f
      race.distance_unit= params[:other_distance_unit]
    elsif params[:race][:distance].end_with?('m')
      race.distance= params[:race][:distance].chop!.to_f
      race.distance_unit= 'mi'
    else
      race.distance= params[:race][:distance].to_f
      race.distance_unit= 'km'
    end
  end
end
