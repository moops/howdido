class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.references :athlete
      t.references :result
      t.integer :participation_type
      t.timestamps
    end
  end

  def self.down
    drop_table :participations
  end
end
