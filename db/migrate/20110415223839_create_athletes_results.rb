class CreateAthletesResults < ActiveRecord::Migration
  def self.up
    create_table :athletes_results, :id => false do |t|
      t.references :athlete
      t.references :result
    end
  end

  def self.down
    drop_table :athletes_results
  end
end
