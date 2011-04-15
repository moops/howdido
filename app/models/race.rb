class Race < ActiveRecord::Base
  has_many :results
  has_and_belongs_to_many :athletes
  
  belongs_to :distance, :class_name => 'Lookup', :foreign_key => 'distance'
  belongs_to :race_type, :class_name => 'Lookup', :foreign_key => 'race_type'
  
  scope :running, where("race_type = 3")
  
  def results_by_division
    h = Hash.new
    for r in results do
      h[r.div] = { "gun" => r.gun_time, "ath" => r.athlete.first_name }
    end
    h
  end
  
end
