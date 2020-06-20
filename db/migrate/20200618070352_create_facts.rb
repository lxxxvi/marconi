class CreateFacts < ActiveRecord::Migration[6.0]
  def change
    create_table :facts do |t|
      t.references :station, null: false, foreign_key: true, index: true
      t.references :factable, polymorphic: true, null: false
      t.string :key, null: false
      t.string :value, null: false
      t.bigint :epoch_year, null: false, default: 0
      t.bigint :epoch_week, null: false, default: 0

      t.index %i[station_id factable_type factable_id key epoch_year epoch_week],
              unique: true,
              name: :indx_station_factable_key_epoch

      t.timestamps
    end
  end
end
