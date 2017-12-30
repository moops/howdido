class CreateUsers < ActiveRecord::Migration[5.2]
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :gender
      t.integer :authority
      t.date :born_on
      t.string :city
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
