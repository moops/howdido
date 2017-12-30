class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create do
    self.roles = ['athlete'] unless authority
  end

  has_many :participations, dependent: :destroy
  has_many :results, through: :participations

  validates :first_name, :last_name, :born_on, :email, presence: true
  validates :email, uniqueness: true

  scope :male, -> { where(gender: 10) }
  scope :female, -> { where(gender: 11) }
  scope :with_role, lambda { |role| { conditions: "authority & #{2**ROLES.index(role.to_s)} > 0" } }

  ROLES = %w[admin athlete].freeze

  def roles=(roles)
    self.authority = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((authority || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

  def admin?
    role?(:admin)
  end

  def role_symbols
    roles.map(&:to_sym)
  end

  # returns: [{'name' => race name, 'date' => race date, 'everyone' => grade, 'gender' => grade, 'div' => grade, 'me' => grade, 'points' => points}, ...]
  # example: [{'name' => 'Esquimalt 8km' 'date' => 2009-07-16, 'everyone' => 56, 'gender' => 59, 'div' => 68, 'me' => 90, points => 650}, ...]
  def run_summaries(limit = 25)
    summaries = []
    participations.me.run.limit(limit).each do |p|
      summaries << run_summary(p.result)
    end
    summaries.sort { |a, b| a['date'] <=> b['date'] }
  end

  def run_summary(my_result)
    race = my_result.race
    h = { everyone: 0, gender: 0, div: 0, me: 0 }
    num_results = 0
    num_results_in_gender = 0
    num_results_in_div = 0

    race.results.each do |result|
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
    h['points'] = my_result.points
    h['date'] = race.race_on
    h['name'] = race.display_name
    h
  end

  def participations_by_race(participation_type='me')
    p_map = {}
    p_list = []
    if participation_type == 'friend'
      p_list = participations.friend
    elsif participation_type == 'rival'
      p_list = participations.rival
    elsif participation_type == 'other'
      p_list = participations.other
    else
      p_list = participations.me
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

  def age
    a = Time.zone.today.year - born_on.year
    a -= 1 if Time.zone.today < born_on + a.years
    a
  end
end
