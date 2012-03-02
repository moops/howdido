class Participation < ActiveRecord::Base

  belongs_to :user
  belongs_to :result
  
  belongs_to :type, :class_name => 'Lookup', :foreign_key => 'participation_type'
  
  attr_accessible :user, :result, :type
  
  validates_presence_of :participation_type
  
  scope :me, where("participation_type = 33")
  scope :friend, where("participation_type = 34")
  scope :rival, where("participation_type = 35")
  scope :other, where("participation_type = 36")
  
  scope :run, joins(:result => :race).where("races.race_type = 3")
  
  def summary
    "#{result.name}, race: #{result.race.name}, time #{result.gun_time} grade: #{result.grade}"
  end
  
  def self.sort_by_race_on(participations)
    participations.sort! { |a,b|
      a.result.race.race_on <=> b.result.race.race_on
    }
  end
  
  def self.find_or_build(options)
    p = find_or_create_by_user_id_and_result_id_and_participation_type(options[:user], options[:result], options[:type])
    p.touch
    p.save
  end
end
