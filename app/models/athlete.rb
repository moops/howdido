require 'open-uri'
require 'rexml/document'

class Athlete < ActiveRecord::Base
  has_and_belongs_to_many :results
  has_and_belongs_to_many :races
  
  belongs_to :gender, :class_name => 'Lookup', :foreign_key => 'gender'
  
  attr_accessor :auth_profile
  
  scope :male, where("gender = 10")
  scope :female, where("gender = 11")
  
  # returns: [[race name,grade]]
  # example: [["Esquimalt 8km", 75], ["Stewart Mountain", 97], ["Chemainus Twilight Shuffle", 64], ["race for pace", 90]]
  def recent_run_grades(limit=10)
    grades = []
    recent_results = results.where("race.race_type = 3").order("race.race_on").limit(limit)
    for race in recent_results do
      grades << [result.race.name, result.race.race_on, result.grade]
    end
    grades
  end
  
  # returns: {race_name => {'everyone' => grade, 'gender' => grade, 'div' => grade, 'me' => grade,}, ...}
  # example: {'Esquimalt 8km' => {'everyone' => 56, 'gender' => 59, 'div' => 68, 'me' => 90,}, ...}
  def recent_run_summaries(limit=5)
    summaries = Hash.new
    for race in races.where("race_type = 3").order("race_on desc").limit(limit) do
      summaries[race.name] = race_summary(race)
    end
    summaries
  end
  
  def race_summary(race)
    h = {'everyone' => 0, 'gender' => 0, 'div' => 0, 'me' => 0}
    num_results = 0
    num_results_in_gender = 0
    num_results_in_div = 0
    my_result = Result.where("race_id = :race and athlete_id = :ath", {:race => race.id, :ath => id}).first
    #logger.info("my_result for #{race.name} [#{my_result.inspect}]")
    for result in race.results do

      if result.grade
        num_results += 1
        h['everyone'] += result.grade
        if result.athlete.gender == gender
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
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def self.authenticate(name, password)
    profile = nil
    resp = nil
    url = "#{APP_CONFIG['auth_host']}/users/find.xml?user_name=#{name}&password=#{password}"
    logger.debug("Athlete.authenticate: authenticating with url[#{url}]...")
    open(url) do |http|
      resp = http.read
    end
    logger.debug("Athlete.authenticate: resp[#{resp}]...")
    
    if !resp.empty?
      root = REXML::Document.new(resp).root
      user = Athlete.find_by_user_name(root.elements["user-name"].text)
      if user
        name = (root.elements["name"].text) if root.elements["name"].text
        authority = (root.elements["authority"].text.to_i) if root.elements["authority"].text
        born_on = (Date.parse(root.elements["born-on"].text)) if root.elements["born-on"].text
        profile = AuthProfile.new(user.id, name, authority, born_on)
      end
    end
    profile
  end
  
end
