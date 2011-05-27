class Participation < ActiveRecord::Base

  belongs_to :athlete
  belongs_to :result
  
  belongs_to :type, :class_name => 'Lookup', :foreign_key => 'participation_type'
  
  validates_presence_of :participation_type
end
