class AddTotalBroadcastsToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :total_broadcasts, :bigint, null: false, default: 0
  end
end
