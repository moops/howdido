module ParticipationsHelper
  def participations(result, user)
    list = ''
    participations = user.participations.where(:result_id => result.id).all
    participations.each do |p|
      list << Lookup.find(p.participation_type).description
      list << link_to("<i class='icon-remove'></i> ".html_safe, participation_path(p), :method => :delete, :remote => true)
    end
    list.html_safe
  end
end
