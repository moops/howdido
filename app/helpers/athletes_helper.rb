module AthletesHelper
  def participation_options_in_race_order(athlete)
    options = Hash.new
    Participation.sort_by_race_on(athlete.participations.me).each do |p|
      options[p.result.race.name] = p.result.race.id
    end
    options_for_select(options)
  end
end
