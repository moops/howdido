class CreateUserSessions < ActiveRecord::Migration
  def self.up
    create_table :user_sessions do |t|
      t.integer :athlete_id
      t.string :name
      t.date :born_on
      t.integer :authority
      t.datetime :login_at
      t.datetime :logout_at
    end
  end

  def self.down
    drop_table :user_sessions
  end
end