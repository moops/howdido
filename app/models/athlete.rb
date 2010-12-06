class Athlete < ActiveRecord::Base
  has_many :results
  has_many :races, :through => :results
  
  belongs_to :gender, :class_name => 'Lookup', :foreign_key => 'gender'
  
  def race_summary(race)
    h = {'everyone' => 0, 'gender' => 0, 'div' => 0, 'me' => 0}
    num_results = 0
    num_results_in_gender = 0
    num_results_in_div = 0
    my_result = Result.where("race_id = :race and athlete_id = :ath", {:race => race.id, :ath => id}).first
    logger.info("my_result for #{race.name} [#{my_result.inspect}]")
    for result in race.results do
      w = Wava.where('age = :age and gender = :gender and distance = :dist', {:age => result.athlete.age(race.race_on), :gender => result.athlete.gender, :dist => race.distance}).first
      
      result.grade= (w.factor / result.gun_time) * 100 if w

      if result.grade
        num_results += 1
        h['everyone'] += result.grade
        if result.athlete.gender == gender
          num_results_in_gender += 1
          h['gender'] += result.grade
        end
        if result.div == my_result.div
          num_results_in_div += 1
          h['div'] += result.grade
        end
        if result.id == my_result.id
          h['me'] += result.grade
        end
      end
    end
    num_results = race.results.size
    h['everyone'] /= num_results if num_results > 0
    h['gender'] /= num_results_in_gender if num_results_in_gender > 0
    h['div'] /= num_results_in_div if num_results_in_div > 0
    
    h['everyone'] = h['everyone'].to_i
    h['gender'] = h['gender'].to_i
    h['div'] = h['div'].to_i
    h['me'] = h['me'].to_i
    
    logger.info("summary built for #{race.name} [#{h.inspect}]")
    h
  end
  
  def guess_birth_date(race_on, div)
    a = nil
    # M5054
    if div[/^[mMfF][0-9]{4}$/]
      if div[1,2].to_i < 2
        # M0119 use upper age
        a = div[3,2].to_i
      else
        # use mid point
        a = (div[1,2].to_i + (div[3,2].to_i + 1)) / 2
      end
    # M50+
    elsif div[/^[mMfF][0-9]{2}\+$/]
      a = div[1,2].to_i
    # M-U20
    elsif div[/^[mMfF]-U[0-9]{2}$/]
      a = (div[3,2].to_i) - 1
    end
    self.birth_date = race_on << (a.floor*12) if age
  end
  
  def guess_gender(div)
    if div[/^[mM]/]
      self.gender = 'm' 
    elsif div[/^[fF]/]
      self.gender = 'f'
    else
      self.gender = 'u'
    end
  end
  
  def age(on = Date.today)
    age = on.year - birth_date.year
    age -= 1 if (on.yday < birth_date.yday)
    age
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
end
