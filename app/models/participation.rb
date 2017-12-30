class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :result

  belongs_to :type, class_name: 'Lookup', foreign_key: 'participation_type'

  validates :participation_type, presence: true

  scope :me, -> { where(participation_type: 33) }
  scope :friend, -> { where(participation_type: 34) }
  scope :rival, -> { where(participation_type: 35) }
  scope :other, -> { where(participation_type: 36) }

  scope :run, -> { joins(result: :race).where('races.race_type = 3') }

  def summary
    "#{result.name}, race: #{result.race.name}, time #{result.gun_time} grade: #{result.grade}"
  end

  # update the age of the result to the age of the user if the participation is 'me'
  def update_result_age_if_me
    if Lookup.code_for('participation_type', 'me').id == participation_type
      result.age = user.age
      result.save
    end
  end

  def self.sort_by_race_on(participations)
    participations.sort! do |a, b|
      a.result.race.race_on <=> b.result.race.race_on
    end
  end

  def self.find_or_build(user, result, type)
    find_or_create_by_user_id_and_result_id_and_participation_type(user, result, type)
  end
end
