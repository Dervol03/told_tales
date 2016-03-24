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

ActiveRecord::Schema.define(version: 20160324114134) do

  create_table "adventures", force: :cascade do |t|
    t.string   "name",                       null: false
    t.text     "setting"
    t.boolean  "started",    default: false
    t.integer  "owner_id",                   null: false
    t.integer  "player_id"
    t.integer  "master_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "adventures", ["name"], name: "index_adventures_on_name", unique: true

  create_table "choices", force: :cascade do |t|
    t.text     "decision",                   null: false
    t.integer  "event_id",                   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "customized", default: false
  end

  add_index "choices", ["event_id"], name: "index_choices_on_event_id"

  create_table "events", force: :cascade do |t|
    t.string   "title",             default: "",    null: false
    t.text     "description",       default: "",    null: false
    t.integer  "adventure_id"
    t.integer  "previous_event_id"
    t.integer  "current_event_id"
    t.boolean  "visited",           default: false
    t.boolean  "ready",             default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "outcome_id"
  end

  add_index "events", ["adventure_id"], name: "index_events_on_adventure_id"
  add_index "events", ["outcome_id"], name: "index_events_on_outcome_id"
  add_index "events", ["previous_event_id"], name: "index_events_on_previous_event_id"
  add_index "events", ["title"], name: "index_events_on_title"

  create_table "users", force: :cascade do |t|
    t.string   "name",                   default: "",    null: false
    t.string   "password"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "is_admin",               default: false
    t.string   "temporary_password"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
