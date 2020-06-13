class CreateExternalKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :external_keys do |t|
      t.references :station, null: false, foreign_key: true
      t.string :identifier
      t.bigint :externally_identifyable_id
      t.string :externally_identifyable_type

      t.index %i[station_id externally_identifyable_type identifier],
              unique: true,
              name: :indx_station_type_identifier

      t.timestamps
    end
  end
end
