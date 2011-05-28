
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
  
  def result_claims(result)
    return unless @current_user
    claims = Participation.where(:athlete_id => @current_user.athlete_id, :result_id => result.id).all.collect { |p| Lookup.find(p.participation_type).description }
    claims.join(' ')
  end
  
  def claim_result_link(result)
    return unless @current_user
    return link_to('mark as...', new_participation_path(:athlete => session[:user_session].athlete_id, :result => result), :class => 'get')
  end
  
  def destroy_claim_link(participation)
    return unless @current_user
    return link_to('remove', participations_path(participation), :class => 'delete')
  end
  
end
