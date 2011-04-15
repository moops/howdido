class Result < ActiveRecord::Base
  belongs_to :race
  has_and_belongs_to_many :athletes
  
  scope :male, joins(:athlete) & Athlete.male
  scope :female, joins(:athlete) & Athlete.female
  
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
      self.gender = Lookup.code_for('gender','m')
    elsif div[/^[fF]/]
      self.gender = Lookup.code_for('gender','f')
    else
      self.gender = Lookup.code_for('gender','o')
    end
  end
  
  def guess_age(div)
    logger.info("guessing age with div #{div}")
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
    logger.info("guessed #{a} for div #{div}")
    self.age = a
    a
  end
  
  def age(on = Date.today)
    age = on.year - birth_date.year
    age -= 1 if (on.yday < birth_date.yday)
    age
  end
end
