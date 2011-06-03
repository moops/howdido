class Participation < ActiveRecord::Base

  belongs_to :athlete
  belongs_to :result
  
  belongs_to :type, :class_name => 'Lookup', :foreign_key => 'participation_type'
  
  validates_presence_of :participation_type
  
  scope :me, where("participation_type = 32")
  scope :friend, where("participation_type = 33")
  scope :rival, where("participation_type = 34")
  scope :other, where("participation_type = 35")
  
  def summary
    "#{result.name}, race: #{result.race.name}, time #{result.gun_time} grade: #{result.grade}"
  end
end
