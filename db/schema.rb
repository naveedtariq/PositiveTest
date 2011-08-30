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

ActiveRecord::Schema.define(:version => 20110830175425) do

  create_table "app_statuses", :force => true do |t|
    t.boolean  "facebook_connected", :default => false
    t.boolean  "fb_friends_fetched", :default => false
    t.boolean  "fb_data_fetched",    :default => false
    t.boolean  "twt_data_fetched",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "facebook_statuses", :force => true do |t|
    t.string   "message"
    t.string   "raw_json"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "friend_id"
    t.string   "feed_type"
    t.string   "unique_fb_id"
  end

  create_table "friends", :force => true do |t|
    t.string   "name"
    t.integer  "fb_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "fb_fetched", :default => false
  end

  create_table "results", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_type"
    t.integer  "positive_score"
    t.integer  "negative_score"
    t.integer  "score"
    t.text     "stats_json",     :limit => 16777215
    t.integer  "messages_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", :force => true do |t|
    t.string   "unique_twitter_id"
    t.string   "message"
    t.string   "raw_json"
    t.integer  "twitter_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_users", :force => true do |t|
    t.string   "name"
    t.string   "screen_name"
    t.boolean  "twt_fetched",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "beneficial_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "email",       :null => false
    t.integer  "facebook_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fb_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end
