class Athlete < ActiveRecord::Base
  
  has_many :participations
  has_many :results, :through => :participations
  has_many :sessions, :class_name => 'UserSession'
      
  validates_presence_of :user_id
  
  scope :male, where("gender = 10")
  scope :female, where("gender = 11")
  
  # returns: [[race name,grade]]
  # example: [["Esquimalt 8km", "2009-04-25", 75], ["Stewart Mountain", "2009-04-25", 97], ["Chemainus Twilight Shuffle", "2009-04-25", 64]]
  def run_grades(limit=10)
    grades = []
    run = Lookup.code_for('race_type', 'run')
    for p in participations.me.all do
      if p.result.race.race_type == run
        grades << [p.result.race.name, p.result.race.race_on, p.result.grade]
      end
    end
    grades
  end
  
  # returns: {race_name => {'everyone' => grade, 'gender' => grade, 'div' => grade, 'me' => grade,}, ...}
  # example: {'Esquimalt 8km' => {'everyone' => 56, 'gender' => 59, 'div' => 68, 'me' => 90,}, ...}
  def run_summaries(limit=5)
    summaries = Hash.new
    run = Lookup.code_for('race_type', 'run')
    for p in participations.me.limit(limit).all do
      if p.result.race.race_type == run
        summaries[p.result.race.name] = run_summary(p.result)
      end
    end
    summaries
  end
  
  def run_summary(my_result)
    race = my_result.race
    h = {'everyone' => 0, 'gender' => 0, 'div' => 0, 'me' => 0}
    num_results = 0
    num_results_in_gender = 0
    num_results_in_div = 0

    for result in race.results do

      if result.grade
        num_results += 1
        h['everyone'] += result.grade
        if result.gender == gender
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
    h
  end
  
  def participations_by_race(participation_type='me')
    p_map = Hash.new
    p_list = Array.new
    if participation_type == 'me'
      p_list = participations.me
    elsif participation_type == 'friend'
      p_list = participations.friend
    elsif participation_type == 'rival'
      p_list = participations.rival
    elsif participation_type == 'other'
      p_list = participations.other
    end
    p_list.each do |p|
      race = p.result.race
      if p_map.include?(race)
        p_map[race] << p
      else
        p_map[race] = [p]
      end
    end
    p_map
  end
  
  def name
    "#{user.first_name} #{user.last_name}"
  end
  
  def gender
    user.gender
  end
  
  def user_name
    user.user_name
  end
  
  def born_on
    user.born_on
  end
  
  def user
    @user ||= User.find(user_id) unless user_id.blank?
  end
  
end
