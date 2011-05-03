class Athlete < ActiveRecord::Base
  has_and_belongs_to_many :results
    
  attr_accessor :auth_profile
  
  scope :male, where("gender = 10")
  scope :female, where("gender = 11")
  
  # returns: [[race name,grade]]
  # example: [["Esquimalt 8km", 75], ["Stewart Mountain", 97], ["Chemainus Twilight Shuffle", 64], ["race for pace", 90]]
  def recent_run_grades(limit=10)
    grades = []
    for result in results.joins(:race).where('race_type = 3').all do
      logger.info("result: #{result.race.inspect}")
      grades << [result.race.name, result.race.race_on, result.grade]
    end
    grades
  end
  
  # returns: {race_name => {'everyone' => grade, 'gender' => grade, 'div' => grade, 'me' => grade,}, ...}
  # example: {'Esquimalt 8km' => {'everyone' => 56, 'gender' => 59, 'div' => 68, 'me' => 90,}, ...}
  def recent_run_summaries(limit=5)
    summaries = Hash.new
    for result in results.joins(:race).where('race_type = 3').order("race_on desc").limit(limit).all do
      summaries[result.race.name] = run_summary(result)
    end
    summaries
  end
  
  def run_summary(my_result)
    race = my_result.race
    logger.info("###myresult: #{my_result.inspect}")
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
  
  def name
    @user ||= User.find(user_id)
    "#{@user.first_name} #{@user.last_name}"
  end
  
  def gender
    @user ||= User.find(user_id)
    @user.gender
  end
  
  def self.authenticate(name, password)
    @user ||= User.find(:first, :params => { :user_name => name, :password => password }) unless name.blank? or password.blank?
    logger.info("### athlete.authenticate @user: #{@user.inspect}")
    profile = nil
    if @user
      profile = AuthProfile.new(@user.id, @user.user_name, @user.authority, @user.born_on)
    end
    profile
  end
  
  def user
    @user ||= User.find(user_id) unless user_id.blank?
  end
  
end
