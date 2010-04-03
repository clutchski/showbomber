# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100329031415) do

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artists", ["name"], :name => "index_artists_on_name"

  create_table "artists_events", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "artist_id"
  end

  add_index "artists_events", ["event_id", "artist_id"], :name => "index_artists_events_on_event_id_and_artist_id", :unique => true

  create_table "events", :force => true do |t|
    t.integer  "venue_id"
    t.datetime "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["start_date"], :name => "index_events_on_start_date"
  add_index "events", ["venue_id"], :name => "index_events_on_venue_id"

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venues", ["city"], :name => "index_venues_on_city"

end
