
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
  
  def claim_result_link(result)
    return unless @current_user
    for p in @user_participations
      return p.participation_type if p.result == result
    end
    return link_to('claim', new_participation_path(:athlete => session[:user_session].athlete_id, :result => result), :class => 'get')
  end
end
