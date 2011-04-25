class CreateAthletesRaces < ActiveRecord::Migration
  def self.up
    create_table :athletes_races, :id => false do |t|
      t.references :athlete
      t.references :race
    end
  end

  def self.down
    drop_table :athletes_races
  end
end
