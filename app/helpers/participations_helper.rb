module ParticipationsHelper
  def participations(result, current_user)
    r = result.claims_for_user(current_user)
    r << link_to("<i class='icon-remove'></i>".html_safe, participation_path, :method => :delete) unless r.empty?
    r.html_safe
  end
end
