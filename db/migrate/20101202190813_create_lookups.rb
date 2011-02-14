class CreateLookups < ActiveRecord::Migration
  def self.up
    create_table :lookups do |t|
      t.integer :category
      t.string :code
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :lookups
  end
end
