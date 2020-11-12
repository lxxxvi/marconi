class CreatePredictions < ActiveRecord::Migration[6.0]
  def change
    create_table :predictions do |t|
      t.date :reference_date, null: false
      t.references :song, null: false
      t.decimal :score, null: false
      t.string :result, null: true

      t.index %i[reference_date song_id], unique: true

      t.timestamps
    end
  end
end
