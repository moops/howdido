class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.integer :gender
      t.integer :authority
      t.date :born_on
      t.string :city
      t.datetime :last_login_at
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
