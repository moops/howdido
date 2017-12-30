class Wava < ApplicationRecord
  def self.find_for(age, gender, distance)
    age_and_gender = 'age = :age and gender = :gender'
    w = Wava.where(age_and_gender << ' and distance > :min and distance < :max', age: age, gender: gender, min: distance - 0.2, max: distance + 0.2).first
    unless w
      # didn't find one. distance probably doesn't match
      upper = find_for_next_distance(age, gender, distance)
      lower = find_for_previous_distance(age, gender, distance)
      if upper && lower
        # found both - use weighted average
        factor = lower.factor + ((distance - lower.distance) / (upper.distance - lower.distance) * (upper.factor - lower.factor))
      end
      w = Wava.new(age: age, gender: gender, distance: distance, factor: factor)
    end
    w
  end

  def self.list_for(distance)
    Wava.where('distance > :min and distance < :max', min: distance - 0.2, max: distance + 0.2).all
  end

  def self.find_for_next_distance(age, gender, distance)
    age_and_gender = 'age = :age and gender = :gender'
    Wava.where(age_and_gender << ' and distance > :dist', { age: age, gender: gender, dist: distance }).order('distance asc').first
  end

  def self.find_for_previous_distance(age, gender, distance)
    age_and_gender = 'age = :age and gender = :gender'
    Wava.where(age_and_gender << ' and distance < :dist', { age: age, gender: gender, dist: distance }).order('distance asc').last
  end
end
