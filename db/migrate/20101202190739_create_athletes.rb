class CreateAthletes < ActiveRecord::Migration
  def self.up
    create_table :athletes do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.string :city
      t.integer :gender
      t.date :birth_date
      t.boolean :accurate_birth_date, :default => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :athletes
  end
end
