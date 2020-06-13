class CreateBroadcasts < ActiveRecord::Migration[6.0]
  def change
    create_table :broadcasts do |t|
      t.references :song, null: false, foreign_key: true
      t.references :station, null: false, foreign_key: true
      t.datetime :broadcasted_at, null: false

      t.index %i[station_id song_id broadcasted_at], unique: true

      t.timestamps
    end
  end
end
