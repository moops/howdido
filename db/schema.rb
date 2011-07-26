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

ActiveRecord::Schema.define(:version => 20110526193907) do

  create_table "lookups", :force => true do |t|
    t.integer  "category"
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "result_id"
    t.integer  "participation_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "races", :force => true do |t|
    t.date     "race_on"
    t.string   "name"
    t.string   "location"
    t.integer  "race_type"
    t.float    "distance"
    t.string   "distance_unit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", :force => true do |t|
    t.integer  "race_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.string   "club"
    t.integer  "age"
    t.integer  "gender"
    t.integer  "overall_place"
    t.integer  "gun_time"
    t.integer  "chip_time"
    t.integer  "penalty_time"
    t.string   "bib"
    t.string   "div"
    t.integer  "div_place"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sessions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "count"
    t.datetime "login_at"
    t.datetime "logout_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.integer  "gender"
    t.integer  "authority"
    t.date     "born_on"
    t.string   "city"
    t.datetime "last_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wavas", :force => true do |t|
    t.integer  "age"
    t.integer  "gender"
    t.float    "distance"
    t.float    "factor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
