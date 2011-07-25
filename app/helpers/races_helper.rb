
module RacesHelper
  
  def results_for_chart
    r = Array.new
    @race.results.each do |result|
      point = { :name => result.user.name, :x => result.user.age, :y => result.gun_time }
      r << point
    end
    logger.info("r.to_json: #{r.to_json}")
    r.to_json
  end
  
  def result_claims(result)
    return unless current_user
    claims = Participation.where(:user_id => current_user.id, :result_id => result.id).all.collect { |p| Lookup.find(p.participation_type).description }
    claims.join(' ')
  end
  
  def claim_result_link(result)
    return unless @current_user
    return link_to(image_tag("add.png", :size => "20x20", :title => "mark this result as..."), new_participation_path(:user => current_user.id, :result => result), :class => 'get')
  end
  
  def destroy_claim_link(participation)
    return unless @current_user
    return link_to('remove', participations_path(participation), :class => 'delete')
  end
  
  def distance_description(race)
    d = race.distance_in_km
    if d and d > 42.1 and d < 42.3
      desc = 'marathon'
    elsif d and d > 21 and d < 21.2
      desc = 'half marathon'
    else
      desc = "#{race.distance} #{race.distance_unit}"
    end
    desc
  end
  
end
