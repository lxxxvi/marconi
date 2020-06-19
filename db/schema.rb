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

ActiveRecord::Schema.define(version: 2020_06_18_070352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "external_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["song_id"], name: "index_broadcasts_on_song_id"
    t.index ["station_id", "broadcasted_at"], name: "index_broadcasts_on_station_id_and_broadcasted_at", unique: true
    t.index ["station_id", "external_key"], name: "index_broadcasts_on_station_id_and_external_key", unique: true
    t.index ["station_id"], name: "index_broadcasts_on_station_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["factable_type", "factable_id"], name: "index_facts_on_factable_type_and_factable_id"
    t.index ["station_id", "factable_type", "factable_id", "key"], name: "indx_station_factable_key", unique: true
    t.index ["station_id"], name: "index_facts_on_station_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "artist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
