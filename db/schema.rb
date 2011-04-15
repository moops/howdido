# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110415233127) do

# Could not dump table "athletes" because of following ArgumentError
#   invalid date

  create_table "athletes_races", :id => false, :force => true do |t|
    t.integer "athlete_id"
    t.integer "race_id"
  end

  create_table "athletes_results", :id => false, :force => true do |t|
    t.integer "athlete_id"
    t.integer "result_id"
  end

# Could not dump table "lookups" because of following ArgumentError
#   invalid date

# Could not dump table "races" because of following ArgumentError
#   invalid date

# Could not dump table "results" because of following ArgumentError
#   invalid date

# Could not dump table "wavas" because of following ArgumentError
#   invalid date

end
