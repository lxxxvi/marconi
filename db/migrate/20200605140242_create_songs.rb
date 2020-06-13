class CreateSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.string :title, null: false
      t.references :artist, null: false, foreign_key: true, index: true

      t.index %i[artist_id title], unique: true

      t.timestamps
    end
  end
end
