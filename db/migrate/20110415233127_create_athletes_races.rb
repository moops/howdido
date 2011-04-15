class CreateAthletesRaces < ActiveRecord::Migration
  def self.up
    create_table :athletes_races, :id => false do |t|
      t.column :athlete_id, :integer
      t.column :race_id, :integer
    end
  end

  def self.down
    drop_table :athletes_races
  end
end
