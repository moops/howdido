class CreateAthletes < ActiveRecord::Migration
  def self.up
    create_table :athletes do |t|
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :athletes
  end
end
