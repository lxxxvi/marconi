class CreateBroadcasts < ActiveRecord::Migration[6.0]
  def change
    create_table :broadcasts do |t|
      t.references :song, null: false, foreign_key: true, index: true
      t.references :station, null: false, foreign_key: true, index: true
      t.datetime :broadcasted_at, null: false
      t.string :external_key

      t.index %i[station_id broadcasted_at], unique: true
      t.index %i[station_id external_key], unique: true

      t.timestamps
    end
  end
end
