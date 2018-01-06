class ResultsController < ApplicationController
  before_action :set_result, only: %i[show edit update destroy]

  # GET /results
  def index
    @race = Race.find(params[:race_id])
    authorize @race
    @results = @race.results
    if params[:q]
      q = "%#{params[:q]}%"
      @results = @results.where('first_name like ? or last_name like ?', q, q)
    end
    @results = @results.page(params[:page])
  end

  # GET /results/1
  def show
    # authorize @result
  end

  # DELETE /results/1
  def destroy
    authorize @result
    @result.destroy
    redirect_to results_path
  end

  # POST /results/load
  def load
    race = Race.find(params[:id])
    first_name_index = params[:first_name_index].to_i unless params[:first_name_index].empty?
    last_name_index = params[:last_name_index].to_i unless params[:last_name_index].empty?
    city_index = params[:city_index].to_i unless params[:city_index].empty?
    club_index = params[:club_index].to_i unless params[:club_index].empty?
    bib_index = params[:bib_index].to_i unless params[:bib_index].empty?
    div_index = params[:div_index].to_i unless params[:div_index].empty?
    overall_place_index = params[:overall_place_index].to_i unless params[:overall_place_index].empty?
    gun_time_index = params[:gun_time_index].to_i unless params[:gun_time_index].empty?
    chip_time_index = params[:chip_time_index].to_i unless params[:chip_time_index].empty?
    penalty_time_index = params[:penalty_time_index].to_i unless params[:penalty_time_index].empty?
    age_index = params[:age_index].to_i unless params[:age_index].empty?
    if params[:div_place_index].empty?
      div_places = {}
    else
      div_place_index = params[:div_place_index].to_i
    end

    data_found = false

    logger.info('loading results...')

    params[:datafile].read.each_line do |l|
      logger.info("reading results line #{l}")

      line = l.split(' ')
      if data_found
        logger.info('data found')
        first_name = line[first_name_index].downcase
        last_name = line[last_name_index].downcase
        logger.info("building result for #{first_name} #{last_name}")

        # create result
        r = Result.new
        # r.user = a if a
        r.first_name = line[first_name_index].downcase
        r.last_name = line[last_name_index].downcase
        r.city = line[city_index] if city_index
        r.club = line[club_index] if club_index
        r.age = line[age_index].to_i if age_index

        if div_index
          r.div = line[div_index]
          r.guess_gender(line[div_index])
          r.guess_age(line[div_index]) unless age_index
        end

        r.race = race if race
        r.overall_place = line[overall_place_index] if overall_place_index
        # use or calculate div_place
        if div_place_index
          r.div_place = line[div_place_index]
        else
          if r.div
            place = (div_places.has_key?(r.div) ? div_places[r.div] + 1 : 1)
            r.div_place = place
            div_places[r.div] = place
          end
        end
        r.bib = line[bib_index] if bib_index
        r.gun_time = get_time(line[gun_time_index]) if gun_time_index
        r.chip_time = get_time(line[chip_time_index]) if chip_time_index
        r.penalty_time = get_time(line[penalty_time_index]) if penalty_time_index
        r.save
      end
      data_found ||= data_header?(line)
    end

    respond_to do |format|
      format.html { redirect_to(races_url) }
      format.xml  { head :ok }
    end
  end

  private

  def set_result
    @result = Result.find(params[:id])
  end

  def get_time(time_string)
    time = 0
    parts = time_string.split(':')
    parts.reverse!
    parts.each_with_index do |p, i|
      time += (p.to_i * (60**i))
    end
    time
  end

  def data_header?(line)
    logger.info("is this a header line? #{line}")
    something_else_found = false
    line.each do |l|
      something_else_found = !(l =~ /^=+$/)
    end
    logger.info("is this a header line? #{!something_else_found && !line.empty?}")
    !something_else_found && !line.empty?
  end
end
