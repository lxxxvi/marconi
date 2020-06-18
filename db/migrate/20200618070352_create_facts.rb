class CreateFacts < ActiveRecord::Migration[6.0]
  def change
    create_table :facts do |t|
      t.references :station, null: true, foreign_key: true
      t.references :factable, polymorphic: true, null: false
      t.string :key, null: false
      t.string :value, null: false

      t.index %i[station_id factable_type factable_id key],
              unique: true,
              name: :indx_station_factable_key

      t.timestamps
    end
  end
end
