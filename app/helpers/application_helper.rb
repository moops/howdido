module ApplicationHelper

  def sortable(params, column, title = nil, remote = false)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    if(remote)
      link_to(title, params.merge(sort: column, direction: direction, page: nil, remote: true), {class: css_class})
    else
      link_to(title, params.merge(sort: column, direction: direction, page: nil), {class: css_class})
    end
  end

  def seconds_to_time(t)
    val = ''
    seconds = t % 60
    minutes = (t / 60) % 60
    hours = t / (60 * 60)
    if (hours > 0)
      val = format("%02d:%02d:%02d", hours, minutes, seconds)
    else
      val = format("%02d:%02d", minutes, seconds)
    end
    val
  end

  def form_errors(errors)
    html  = ""
    if errors.any?
      html  << "<div id=\"error_explanation\">"
      html  << "  <h2>#{pluralize(errors.count, 'error')} prohibited this race from being saved:</h2>"
      html  << "<ul>"
      errors.full_messages.each do |msg|
        html  << "    <li>#{msg}</li>"
      end
      html  << "</ul>"
      html  << "</div>"
    end
    html.html_safe
  end

  def notice
    html = ''
    if flash[:notice]
        html << '<div id="notice" class="alert alert-block alert-success fade in">'
        html << '   <a class="close" data-dismiss="alert">x</a>'
        html << '   <strong>note: </strong>'
        html <<     flash[:notice]
        html << '</div>'
    end
    raw(html)
  end

  def warning
    html = ''
    if flash[:warning]
        html << '<div id="notice" class="alert alert-block alert-warning">'
        html << '   <a class="close" data-dismiss="warning">x</a>'
        html << '   <strong>warning: </strong>'
        html <<     flash[:warning]
        html << '</div>'
    end
    raw(html)
  end

  def series_data(data)
    r = data.map do |result|
      "{ name: \"#{result.name}\", x: #{result.age}, y: #{result.gun_time/60} }".html_safe
    end
    raw(r.join(', '))
  end

end
