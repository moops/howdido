module ApplicationHelper
  
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
