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

ActiveRecord::Schema.define(:version => 20130311235226) do

  create_table "activity_duration_types", :force => true do |t|
    t.string   "activity_duration_type_id"
    t.string   "activity_duration_name"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "activity_time_types", :force => true do |t|
    t.string   "activity_time_type_id"
    t.string   "activity_period"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "activity_types", :force => true do |t|
    t.string   "activity_type_id"
    t.string   "activity_name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "author_infos", :force => true do |t|
    t.string   "author_id"
    t.string   "author_name"
    t.string   "bithday"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "country"
    t.string   "postal_code"
    t.string   "phone"
    t.string   "email"
    t.string   "website"
    t.string   "twitter_handle"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "state"
    t.string   "blurb"
  end

  add_index "author_infos", ["email"], :name => "auth_email_index", :unique => true

  create_table "food_activities", :force => true do |t|
    t.string   "activity_id"
    t.string   "restaurant_detail_id"
    t.string   "description"
    t.string   "quick_tip"
    t.string   "duration"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.text     "image_urls"
  end

  add_index "food_activities", ["restaurant_detail_id"], :name => "restaurant_detail_index"

  create_table "location_activities", :force => true do |t|
    t.string   "activity_id"
    t.string   "location_detail_id"
    t.string   "description"
    t.string   "quick_tip"
    t.string   "duration"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.text     "image_urls"
  end

  add_index "location_activities", ["location_detail_id"], :name => "location_detail_index"

  create_table "location_details", :force => true do |t|
    t.string   "location_detail_id"
    t.string   "name"
    t.string   "description"
    t.string   "category"
    t.string   "phone"
    t.string   "website"
    t.string   "open_hours"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.text     "image_urls"
    t.string   "location_id"
  end

  add_index "location_details", ["location_detail_id"], :name => "location_detail_index", :unique => true

  create_table "locations", :force => true do |t|
    t.string   "location_id"
    t.string   "place"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "locations", ["location_id"], :name => "location_index", :unique => true

  create_table "restaurant_details", :force => true do |t|
    t.string   "restaurant_detail_id"
    t.string   "name"
    t.string   "description"
    t.string   "category"
    t.string   "phone"
    t.string   "website"
    t.string   "open_hours"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.text     "image_urls"
    t.string   "location_id"
  end

  add_index "restaurant_details", ["restaurant_detail_id"], :name => "restaurant_detail_index", :unique => true

  create_table "transport_activities", :force => true do |t|
    t.string   "activity_id"
    t.string   "transport_quick_tips"
    t.string   "transport_type_id"
    t.string   "duration"
    t.string   "source"
    t.string   "destination"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "transport_types", :force => true do |t|
    t.string   "transport_type_id"
    t.string   "transport_name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "traveler_types", :force => true do |t|
    t.string   "traveler_type_id"
    t.string   "traveler_type_name"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "traveler_types", ["traveler_type_id"], :name => "traveler_type_index"

  create_table "trip_activities", :force => true do |t|
    t.string   "trip_id"
    t.integer  "activity_id"
    t.string   "activity_day"
    t.integer  "activity_sequence_number"
    t.string   "activity_type"
    t.string   "activity_time_type"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "trip_activities", ["trip_id", "activity_day", "activity_sequence_number"], :name => "trip_activity_order_index", :unique => true
  add_index "trip_activities", ["trip_id"], :name => "trip_index"

  create_table "trip_comments", :force => true do |t|
    t.string   "trip_id"
    t.string   "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "trip_stats", :force => true do |t|
    t.string   "trip_id"
    t.float    "total_rating"
    t.integer  "numbers_rated"
    t.integer  "likes"
    t.integer  "tweets"
    t.integer  "fb_shared"
    t.integer  "pinned"
    t.integer  "emailed"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "trips", :force => true do |t|
    t.string   "trip_id"
    t.string   "author_id"
    t.string   "location_id"
    t.string   "traveler_type_id"
    t.string   "trip_name"
    t.string   "trip_summary"
    t.string   "duration"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.text     "image_url"
    t.boolean  "featured_trip_flag"
  end

end
