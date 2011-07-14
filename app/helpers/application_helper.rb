module ApplicationHelper
  
  def sortable(column, title = nil, remote = false)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    if(remote)
      link_to(title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => 'get'})
    else
      link_to(title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class})
    end
  end
  
  def seconds_to_time(t)
    val = ''
    if (t)
      h = t / 1.hours
      m = (t - h.hours) / 1.minutes
      s = (t - (h.hours + m.minutes)) 
      if (h > 0)
        val << "#{h.to_i}:"
      end
      if (m > 0)
        val << "#{m.to_s.rjust(2,'0')}:#{s}"
       end
     end
     val
  end
  
  
  def form_errors(errors)
    val = ''
    if errors.any?
      val << "<div id=\"error_explanation\">"
      val << "  <h2>#{pluralize(errors.count, 'error')} prohibited this race from being saved:</h2>"
      val << "<ul>"
      errors.full_messages.each do |msg|
        val << "    <li>#{msg}</li>"
      end
      val << "</ul>"
      val << "</div>"
    end
  end
  
end
