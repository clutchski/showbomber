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

ActiveRecord::Schema.define(:version => 20110503044407) do

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.text     "freebase_id"
  end

  add_index "artists", ["name"], :name => "index_artists_on_name"

  create_table "artists_events", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "artist_id"
  end

  add_index "artists_events", ["event_id", "artist_id"], :name => "index_artists_events_on_event_id_and_artist_id", :unique => true

  create_table "artists_tags", :id => false, :force => true do |t|
    t.integer "artist_id"
    t.integer "tag_id"
  end

  add_index "artists_tags", ["artist_id", "tag_id"], :name => "index_artists_tags_on_artist_id_and_tag_id", :unique => true

  create_table "events", :force => true do |t|
    t.integer  "venue_id"
    t.datetime "start_date"
    t.integer  "min_cost"
    t.integer  "max_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true, :null => false
  end

  add_index "events", ["active"], :name => "index_events_on_active"
  add_index "events", ["start_date"], :name => "index_events_on_start_date"
  add_index "events", ["venue_id"], :name => "index_events_on_venue_id"

  create_table "songs", :force => true do |t|
    t.integer "artist_id"
    t.string  "url"
    t.text    "name"
  end

  add_index "songs", ["artist_id"], :name => "index_songs_on_artist_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venues", ["city"], :name => "index_venues_on_city"

end
