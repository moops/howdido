
module RacesHelper
  
  def results_for_chart
    r = Array.new
    @race.results.each do |result|
      point = { :name => result.athlete.name, :x => result.athlete.age, :y => result.gun_time }
      r << point
    end
    logger.info("r.to_json: #{r.to_json}")
    r.to_json
  end
  
end
