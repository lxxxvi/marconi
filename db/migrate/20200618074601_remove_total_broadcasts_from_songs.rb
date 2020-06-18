class RemoveTotalBroadcastsFromSongs < ActiveRecord::Migration[6.0]
  def change
    remove_column :songs, :total_broadcasts, :bigint, default: 0, null: false
  end
end
