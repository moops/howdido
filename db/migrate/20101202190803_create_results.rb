class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.references :race
      t.string :first_name
      t.string :last_name
      t.string :city
      t.integer :age
      t.integer :gender
      t.integer :overall_place
      t.integer :gun_time 
      t.integer :chip_time
      t.integer :penalty_time
      t.string :bib
      t.string :div
      t.integer :div_place

      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end
