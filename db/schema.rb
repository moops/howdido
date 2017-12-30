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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2017_12_01_072410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lookups", force: :cascade do |t|
    t.integer "category"
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "result_id"
    t.integer "participation_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["result_id"], name: "index_participations_on_result_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "races", force: :cascade do |t|
    t.date "race_on"
    t.string "name"
    t.string "location"
    t.integer "race_type"
    t.float "distance"
    t.string "distance_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", force: :cascade do |t|
    t.bigint "race_id"
    t.string "first_name"
    t.string "last_name"
    t.string "city"
    t.string "club"
    t.integer "age"
    t.integer "gender"
    t.integer "overall_place"
    t.integer "gun_time"
    t.integer "chip_time"
    t.integer "penalty_time"
    t.string "bib"
    t.string "div"
    t.integer "div_place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_results_on_race_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "gender"
    t.integer "authority"
    t.date "born_on"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wavas", force: :cascade do |t|
    t.integer "age"
    t.integer "gender"
    t.float "distance"
    t.float "factor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
