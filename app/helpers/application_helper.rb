module ApplicationHelper
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to(title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class})
  end
  
  def seconds_to_time(s)
    val = ''
    if (s)
      m = s / 1.minutes
      seconds_in_last_minute = s - m.to_i.minutes.seconds
      val = "#{m.to_i}:#{number_with_precision(seconds_in_last_minute, :precision => 2)}"
     end
     val
  end
  
end
