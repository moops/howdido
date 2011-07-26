class Wava < ActiveRecord::Base

  def self.find_for(age, gender, distance)
    max_dist = distance + 0.2
    min_dist = distance - 0.2
    Wava.where('age = :age and gender = :gender and distance > :min_dist and distance < :max_dist', {:age => age, :gender => gender, :min_dist => min_dist, :max_dist => max_dist}).first
  end
  
  def self.list_for(distance)
    max_dist = distance + 0.2
    min_dist = distance - 0.2
    Wava.where('distance > :min_dist and distance < :max_dist', {:min_dist => min_dist, :max_dist => max_dist}).all
  end
end
