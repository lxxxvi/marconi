class AddIndexOnBroadcastsStationIdExternalKey < ActiveRecord::Migration[6.0]
  def change
    add_index :broadcasts, %i[station_id external_key], unique: true
  end
end
