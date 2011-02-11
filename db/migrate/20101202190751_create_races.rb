class CreateRaces < ActiveRecord::Migration
  def self.up
    create_table :races do |t|
      t.date :race_on
      t.string :name
      t.string :location
      t.integer :race_type
      t.float :distance
      t.timestamps
    end
  end

  def self.down
    drop_table :races
  end
end
