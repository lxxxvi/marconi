# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_10_150100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "tablefunc"

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_artists_on_name", unique: true
  end

  create_table "broadcasts", force: :cascade do |t|
    t.bigint "song_id", null: false
    t.bigint "station_id", null: false
    t.datetime "broadcasted_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "external_key"
    t.index ["song_id"], name: "index_broadcasts_on_song_id"
    t.index ["station_id", "external_key"], name: "index_broadcasts_on_station_id_and_external_key", unique: true
    t.index ["station_id", "song_id", "broadcasted_at"], name: "index_broadcasts_on_station_id_and_song_id_and_broadcasted_at", unique: true
    t.index ["station_id"], name: "index_broadcasts_on_station_id"
  end

  create_table "cached_artist_facts", id: false, force: :cascade do |t|
    t.integer "station_id"
    t.integer "artist_id"
    t.string "average_seconds_between_broadcasts"
    t.string "first_broadcasted_at"
    t.string "latest_broadcasted_at"
    t.string "total_broadcasts"
    t.index ["artist_id"], name: "index_artist_id_on_cached_artist_facts"
  end

  create_table "cached_song_facts", id: false, force: :cascade do |t|
    t.integer "station_id"
    t.integer "song_id"
    t.string "average_seconds_between_broadcasts"
    t.string "first_broadcasted_at"
    t.string "latest_broadcasted_at"
    t.string "total_broadcasts"
    t.index ["song_id"], name: "index_song_id_on_cached_song_facts"
  end

  create_table "cleaned_broadcasts", id: false, force: :cascade do |t|
    t.bigint "broadcast_id"
    t.bigint "song_id"
    t.bigint "station_id"
    t.datetime "broadcasted_at"
    t.datetime "previous_broadcasted_at"
    t.datetime "next_broadcasted_at"
    t.index ["broadcast_id"], name: "index_broadcast_id_on_cleaned_broadcasts"
  end

  create_table "external_keys", force: :cascade do |t|
    t.bigint "station_id", null: false
    t.string "identifier"
    t.bigint "externally_identifyable_id"
    t.string "externally_identifyable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["station_id", "externally_identifyable_type", "identifier"], name: "indx_station_type_identifier", unique: true
    t.index ["station_id"], name: "index_external_keys_on_station_id"
  end

  create_table "facts", force: :cascade do |t|
    t.bigint "station_id", null: false
    t.string "factable_type", null: false
    t.bigint "factable_id", null: false
    t.string "key", null: false
    t.string "value", null: false
    t.bigint "epoch_year", default: 0, null: false
    t.bigint "epoch_week", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["factable_type", "factable_id"], name: "index_facts_on_factable_type_and_factable_id"
    t.index ["station_id", "factable_type", "factable_id", "key", "epoch_year", "epoch_week"], name: "indx_station_factable_key_epoch", unique: true
    t.index ["station_id"], name: "index_facts_on_station_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "artist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "ch_charts_scraper_enabled", default: true, null: false
    t.string "ch_charts_scraper_url"
    t.string "ch_charts_scraper_status", null: false
    t.datetime "ch_charts_scraper_status_updated_at", null: false
    t.index ["artist_id", "title"], name: "index_songs_on_artist_id_and_title", unique: true
    t.index ["artist_id"], name: "index_songs_on_artist_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_stations_on_name", unique: true
  end

  add_foreign_key "broadcasts", "songs"
  add_foreign_key "broadcasts", "stations"
  add_foreign_key "external_keys", "stations"
  add_foreign_key "facts", "stations"
  add_foreign_key "songs", "artists"
end
