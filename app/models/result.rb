class Result < ActiveRecord::Base
  
  belongs_to :race
  has_many :participations
  has_many :users, :through => :participations
  
  # belongs_to :gender, :class_name => 'Lookup', :foreign_key => 'gender'
  
  scope :male, where('gender = 10')
  scope :female, where('gender = 11')
  
  attr_accessor :grade

  def summary_xml
    # results = Result.find(:all, :conditions => ['race_id = ?', self.race_id])
    results = self.race.results
    oa_winner = nil
    div_winner = nil
    num_oa_faster = 0
    num_oa_slower = 0
    num_oa = results.size
    num_div = 0
    perc_to_oa_winner = -1
    perc_to_div_winner = -1
    logger.debug('self: ' + self.inspect)
    
    results.each do |r|
      logger.debug('result: ' + r.inspect)
      num_oa_faster += 1 if r.overall_place < self.overall_place
      num_oa_slower += 1 if r.overall_place > self.overall_place
      num_div += 1 if r.div == self.div
      oa_winner = r if r.overall_place == 1
      div_winner = r if r.div_place == 1 and r.div == self.div
    end
    logger.debug('oa winner: ' + oa_winner.inspect)
    logger.debug('div winner: ' + div_winner.inspect)

    if oa_winner
      perc_to_oa_winner = (self.gun_time - oa_winner.gun_time).to_f / oa_winner.gun_time * 100
    end
    if div_winner
      perc_to_div_winner = (self.gun_time - div_winner.gun_time).to_f / div_winner.gun_time * 100
    end
    
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, :version=>"1.0"
    xml.result {
      xml.athlete(self.athlete.first_name + ' ' + self.athlete.last_name)
      xml.race(self.race.name)
      xml.num_race(num_oa)
      xml.num_div(results.size)
      xml.div(self.div)
      xml.percent_oa_winner_gun(perc_to_oa_winner)
      xml.percent_div_winner_gun(perc_to_div_winner)
      xml.num_oa_faster(num_oa_faster)
      xml.perc_oa_faster(num_oa_faster.to_f / num_oa * 100)
      xml.num_oa_slower(num_oa_slower)
      xml.results {
        results.each do |r|
          xml.result { |x|
            x.athlete_id(r.athlete.id)
            x.div(r.div)
            x.bib(r.bib)
            x.overall_place(r.overall_place)
            x.div_place(r.div_place)
            x.gun_time(r.gun_time)
          }
        end
      }
      # xml.perc_div_faster(num_div_faster.to_f / num_div * 100)
    }

  end

  def guess_gender(div)
    if div[/^[mM]/]
      self.gender = Lookup.code_for('gender','m').id
    elsif div[/^[fF]/]
      self.gender = Lookup.code_for('gender','f').id
    else
      self.gender = Lookup.code_for('gender','o').id
    end
    self.gender
  end
  
  def guess_age(div)
    a = nil
    # M5054
    if div[/^[mMfF][0-9]{4}$/]
      if div[1,2].to_i < 2
        # M0119 use upper age
        a = div[3,2].to_i
      elsif div[3,2].to_i == 99
        # M6099 use lower age
        a = div[1,2].to_i
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
    self.age = a
  end
  
  def grade
    if race.distance
      w = Wava.find_for(age, gender, race.distance_in_km)
      (w.factor / gun_time) * 100
    end
  end
  
  def points
    if race.distance
      return (141113 * (race.distance_in_km ** 1.0689) / gun_time).round(1);
    end
  end
  
  def div_winner
    Result.where(:race_id => race, :div => div).order(:overall_place).first
  end
  
  def finisher_count(type = nil)
    if (type == 'g')
      race.results.where("gender = #{gender}").count
    elsif(type == 'd')
      race.results.where("div = '#{div}'").count
    else
      race.results.size
    end
  end
  
  def people_beat_count(type = nil)
    if (type == 'g')
      race.results.where("gender = #{gender} and overall_place > #{overall_place}").count
    elsif (type == 'd')
      race.results.where("div = '#{div}' and overall_place > #{overall_place}").count
    else
      race.results.where("overall_place > #{overall_place}").count
    end
  end
  
  def people_beat_percentage(type = nil)
    people_beat_count(type).to_f / finisher_count(type) * 100
  end
  
  def future_time_for_same_grade(years = 1)
    if race.distance
      w = Wava.find_for(age + years, gender, race.distance_in_km)
      (w.factor / grade) * 100
    end
  end
  
  def future_grade_with_same_time(years = 1)
    if race.distance
      w = Wava.find_for(age + years, gender, race.distance_in_km)
      (w.factor / gun_time) * 100
    end
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def claims_for_user(user)
    return unless user and !user.participations.empty?
    claims = participations.where(:user_id => user.id).all.collect { |p| p.type.description }
    claims.join(' ')
  end
  
end
