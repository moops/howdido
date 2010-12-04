class Athlete < ActiveRecord::Base
  has_many :results
  has_many :races, :through => :results
  
  belongs_to :gender, :class_name => 'Lookup', :foreign_key => 'gender'
  
  def guess_birth_date(race_on, div)
    age = nil
    # M5054
    if div[/^[mMfF][0-9]{4}$/]
      if div[1,2].to_i < 2
        # M0119 use upper age
        age = div[3,2].to_i
      else
        # use mid point
        age = (div[1,2].to_i + (div[3,2].to_i + 1)) / 2
      end
    # M50+
    elsif div[/^[mMfF][0-9]{2}\+$/]
      age = div[1,2].to_i
    # M-U20
    elsif div[/^[mMfF]-U[0-9]{2}$/]
      age = (div[3,2].to_i) - 1
    end
    self.birth_date = race_on << (age.floor*12) if age
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
end
