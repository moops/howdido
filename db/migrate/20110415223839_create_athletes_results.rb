class CreateAthletesResults < ActiveRecord::Migration
  def self.up
    create_table :athletes_results, :id => false do |t|
      t.column :athlete_id, :integer
      t.column :result_id, :integer
    end
  end

  def self.down
    drop_table :athletes_results
  end
end
