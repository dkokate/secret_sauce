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

ActiveRecord::Schema.define(version: 20131013232612) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "interests", force: true do |t|
    t.integer  "user_id"
    t.integer  "platter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interests", ["platter_id"], name: "index_interests_on_platter_id", using: :btree
  add_index "interests", ["user_id", "platter_id"], name: "index_interests_on_user_id_and_platter_id", unique: true, using: :btree
  add_index "interests", ["user_id"], name: "index_interests_on_user_id", using: :btree

  create_table "platters", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_platter_activity_at"
  end

  add_index "platters", ["last_platter_activity_at"], name: "index_platters_on_last_platter_activity_at", using: :btree
  add_index "platters", ["user_id", "created_at"], name: "index_platters_on_user_id_and_created_at", using: :btree

  create_table "recipes", force: true do |t|
    t.string   "name"
    t.string   "instructions"
    t.integer  "user_id"
    t.integer  "total_calories"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipes", ["user_id", "created_at"], name: "index_recipes_on_user_id_and_created_at", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "selections", force: true do |t|
    t.integer  "platter_id"
    t.integer  "source_recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "selections", ["platter_id", "source_recipe_id"], name: "index_selections_on_platter_id_and_source_recipe_id", unique: true, using: :btree
  add_index "selections", ["platter_id"], name: "index_selections_on_platter_id", using: :btree
  add_index "selections", ["source_recipe_id"], name: "index_selections_on_source_recipe_id", using: :btree

  create_table "source_recipes", force: true do |t|
    t.string   "source"
    t.string   "recipe_ref"
    t.string   "name"
    t.text     "ingredients"
    t.integer  "total_time_in_seconds"
    t.string   "small_image_url"
    t.string   "source_display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  default: false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
