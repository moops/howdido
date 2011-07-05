class User < ActiveRecord::Base

  attr_accessible :email, :password, :password_confirmation, :city, :first_name, :last_name, :born_on, :authority, :gender
  attr_accessor :password
  before_save :encrypt_password
  
  has_many :participations
  has_many :results, :through => :participations
  has_many :sessions, :class_name => 'UserSession'
      
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  
  scope :male, where("gender = 10")
  scope :female, where("gender = 11")
  
  # returns: {race_name => {'everyone' => grade, 'gender' => grade, 'div' => grade, 'me' => grade,}, ...}
  # example: {'Esquimalt 8km' => {'everyone' => 56, 'gender' => 59, 'div' => 68, 'me' => 90,}, ...}
  def run_summaries(limit=25)
    summaries = Array.new
    run = Lookup.code_for('race_type', 'run')
    for p in participations.me.run.limit(limit).all do
      summaries << run_summary(p.result)
    end
    summaries.sort { |a,b| a['date'] <=> b['date']}
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
    h['date'] = race.race_on
    h['name'] = race.name
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
    "#{first_name} #{last_name}"
  end
  
  def self.authenticate(email, password)
    logger.debug("trying to authenticate with email: #{email} password: #{password}")
    user = find_by_email(email)
    logger.debug("found user: #{user.inspect}")
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
end
