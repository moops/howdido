
module RacesHelper
  
  def claim_result_link(result)
    return unless @current_user
    return link_to(image_tag("add.png", :size => "20x20", :title => "mark this result as..."), new_participation_path(:user => current_user.id, :result => result), :class => 'get')
  end
  
  def destroy_claim_link(participation)
    return unless @current_user
    return link_to('remove', participation_path(participation), :class => 'delete')
  end
  
  def participations(result, current_user)
    r = result.claims_for_user(current_user)
    r << link_to("<i class='icon-remove'></i>".html_safe, participation_path, :method => :delete) unless r.empty?
    r.html_safe
  end
  
end
