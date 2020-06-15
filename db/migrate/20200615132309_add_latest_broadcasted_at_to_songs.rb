class AddLatestBroadcastedAtToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :latest_broadcasted_at, :datetime, null: true
  end
end
