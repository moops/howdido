class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.integer :user_id
      t.integer :count
      t.datetime :login_at
      t.datetime :logout_at
    end
  end

  def self.down
    drop_table :sessions
  end
end
