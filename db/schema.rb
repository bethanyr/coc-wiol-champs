# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20190401193555) do

  create_table "day1_awts", force: :cascade do |t|
    t.string   "entryclass"
    t.float    "runner1_float_time"
    t.time     "runner1_time"
    t.integer  "runner1_id"
    t.float    "runner2_float_time"
    t.time     "runner2_time"
    t.integer  "runner2_id"
    t.float    "runner3_float_time"
    t.time     "runner3_time"
    t.integer  "runner3_id"
    t.float    "awt_float_time"
    t.time     "awt_time"
    t.float    "cat_float_time"
    t.time     "cat_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "day2_awts", force: :cascade do |t|
    t.string   "entryclass"
    t.float    "runner1_float_time"
    t.time     "runner1_time"
    t.integer  "runner1_id"
    t.float    "runner2_float_time"
    t.time     "runner2_time"
    t.integer  "runner2_id"
    t.float    "runner3_float_time"
    t.time     "runner3_time"
    t.integer  "runner3_id"
    t.float    "awt_float_time"
    t.time     "awt_time"
    t.float    "cat_float_time"
    t.time     "cat_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "runners", force: :cascade do |t|
    t.integer  "database_id"
    t.string   "surname"
    t.string   "firstname"
    t.string   "gender"
    t.string   "school"
    t.string   "school_short"
    t.string   "entryclass"
    t.string   "class_category"
    t.boolean  "non_compete1"
    t.time     "time1"
    t.float    "float_time1"
    t.string   "classifier1"
    t.boolean  "non_compete2"
    t.time     "time2"
    t.float    "float_time2"
    t.string   "classifier2"
    t.time     "total_time"
    t.float    "float_total_time"
    t.float    "day1_score"
    t.float    "day2_score"
    t.float    "total_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "jrotc"
  end

  create_table "team_members", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "runner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_members", ["runner_id"], name: "index_team_members_on_runner_id"
  add_index "team_members", ["team_id"], name: "index_team_members_on_team_id"

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "entryclass"
    t.string   "JROTC_branch"
    t.float    "day1_score"
    t.float    "day2_score"
    t.float    "total_score"
    t.float    "sort_score"
    t.string   "school"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

end
