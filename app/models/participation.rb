class Participation < ActiveRecord::Base
  belongs_to :athlete
  belongs_to :result
end
