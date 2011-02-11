module ApplicationHelper
  
  def seconds_to_time(s)
    m = s / 1.minutes
   seconds_in_last_minute = s - m.minutes.seconds
   "#{m}:#{seconds_in_last_minute}"
  end
end
