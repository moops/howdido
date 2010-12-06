class Athlete < ActiveRecord::Base
  has_many :results
  has_many :races, :through => :results
  
  belongs_to :gender, :class_name => 'Lookup', :foreign_key => 'gender'
  
  def race_summary(race)
    h = {'everyone' => 0, 'gender' => 0, 'div' => 0, 'me' => 0}
    my_result = Result.where("race_id = :race and athlete_id = :ath", {:race => race.id, :ath => id}).first
    logger.info("my_result[#{my_result.inspect}]")
    for result in race.results do
      w = Wava.where('age = :age and gender = :gender and distance = :dist', {:age => age, :gender => gender, :dist => race.distance}).first
      result.grade= (result.gun_time / w.factor) * 100 if w
      h['everyone'] += result.grade if result.grade
      h['gender'] += result.grade if result.athlete.gender = gender and result.grade
      h['div'] += result.grade if result.div = my_result.div and result.grade
      h['me'] += result.grade if result.id = my_result.id and result.grade
    end
    logger.info("h[#{h.inspect}]")
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
  
  def age
    age = Date.today.year - birth_date.year
    age -= 1 if (Date.today.yday < birth_date.yday)
    age
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
end
