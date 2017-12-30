class RacesController < ApplicationController
  before_action :set_race, only: %i[show edit update destroy]
  helper_method :sort_column, :sort_direction

  # GET /races
  def index
    authorize Race
    @races = Race.search(race_search_params[:q]).order("#{sort_column} #{sort_direction}").page(race_search_params[:page]).per(10)
  end

  # GET /races/1
  # GET /races/1.js
  def show
    authorize @race
    @user_participations = current_user ? current_user.participations : nil
    @results = @race.results.page(params[:page])
  end

  # GET /races/new
  def new
    @race = Race.new
    authorize @race
  end

  # GET /races/1/edit.js
  def edit
    authorize @race
  end

  # POST /races
  def create
    authorize Race
    @race = Race.new(race_params)
    set_distance(params, @race)
    if @race.save
      redirect_to(@race, notice: 'Race was successfully created.')
    else
      render action: 'new'
    end
  end

  # PUT /races/1
  def update
    authorize @race
    set_distance(params, @race)
    params[:race].delete('distance')
    respond_to do |format|
      if @race.update_attributes(race_params)
        format.html { redirect_to(@race, { notice: 'Race was successfully updated.' }) }
      else
        format.html render action: 'edit'
      end
    end
  end

  # DELETE /races/1
  def destroy
    authorize @race
    @race.destroy
    redirect_to races_path
  end

  private

  def set_race
    @race = Race.find(params[:id])
  end

  def race_params
    params.require(:race).permit(:name, :location, :type, :distance, :race_on, :race_type)
  end

  def race_search_params
    @race_search_params = params.permit(:q, :page, :sort, :direction)
  end

  # used in index action to sort races list
  def sort_column
    Race.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def set_distance(params, race)
    if params[:race][:distance] == 'other'
      race.distance = params[:other_distance].to_f
      race.distance_unit = params[:other_distance_unit]
    elsif params[:race][:distance].end_with?('m')
      race.distance = params[:race][:distance].chop!.to_f
      race.distance_unit = 'mi'
    else
      race.distance = params[:race][:distance].to_f
      race.distance_unit = 'km'
    end
  end
end
