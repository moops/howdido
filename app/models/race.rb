class Race < ActiveRecord::Base
  
  has_many :results
  
  validates_presence_of :name
  validates_presence_of :race_on
  validates_uniqueness_of :name
  
  scope :running, where("race_type = 3")
  
  def self.search(search)
    if search
      where('UPPER(name) LIKE ? or UPPER(location) LIKE ?', "%#{search.upcase}%", "%#{search.upcase}%")
    else
      scoped
    end
  end
  
  def results_by_division
    h = Hash.new
    for r in results do
      h[r.div] = { "gun" => r.gun_time, "ath" => r.user.first_name }
    end
    h
  end
  
  def finisher_count
    results.size
  end
  
  def description
    (race_type ? Lookup.find(race_type).description : '') << 
    (distance ? " (#{distance.to_s} #{distance_unit})" : '')  <<  
    (race_on ? ' on ' << race_on.strftime('%A %b %d %Y') : '') << (location ? ' at ' << location : '')
  end
  
  def winner(div = nil, gender = 10)
    if div
      winner_rank = results.where('div = ?', div).minimum('overall_place')
    else
      winner_rank = results.minimum('overall_place')
    end
    results.where('overall_place = ?', winner_rank).first
  end
  
  def gender_winner(gender = 10)
    if gender
      winner_rank = results.where('gender = ?', gender).minimum('overall_place')
    else
      winner_rank = results.male.minimum('overall_place')
    end
    results.where('overall_place = ?', winner_rank).first
  end
  
  def display_name
    race_on.year.to_s << ' ' << name
  end
  
  def distance_in_km
    distance_unit == 'mi' ? (distance * 1.609344).round(2) : distance
  end
  
end
