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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130415165213) do

  create_table "relationships", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["receiver_id"], :name => "index_relationships_on_receiver_id"
  add_index "relationships", ["sender_id", "receiver_id"], :name => "index_relationships_on_sender_id_and_receiver_id", :unique => true
  add_index "relationships", ["sender_id"], :name => "index_relationships_on_sender_id"

  create_table "stories", :force => true do |t|
    t.string   "content"
    t.integer  "creator_id",                :null => false
    t.integer  "owner_id",                  :null => false
    t.integer  "reply_id"
    t.integer  "rating",     :default => 0
    t.integer  "reply_num",  :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "stories", ["creator_id", "created_at"], :name => "index_stories_on_creator_id_and_created_at"
  add_index "stories", ["owner_id", "created_at"], :name => "index_stories_on_owner_id_and_created_at"

  create_table "users", :force => true do |t|
    t.string   "unique_id",                          :null => false
    t.string   "display_name",                       :null => false
    t.string   "email"
    t.string   "password_digest",                    :null => false
    t.string   "session_token",                      :null => false
    t.integer  "user_type",                          :null => false
    t.integer  "coins",           :default => 0
    t.boolean  "admin",           :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "zipcode"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.integer  "house_id"
    t.integer  "founder_id"
    t.integer  "mayor_id"
  end

  add_index "users", ["session_token"], :name => "index_users_on_session_token"
  add_index "users", ["unique_id"], :name => "index_users_on_unique_id", :unique => true

end
