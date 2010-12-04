class CreateWavas < ActiveRecord::Migration
  def self.up
    create_table :wavas do |t|
      t.integer :age
      t.integer :gender
      t.integer :distance
      t.float :factor
      t.timestamps
    end
  end

  def self.down
    drop_table :wavas
  end
end
