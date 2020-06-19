class RemoveLatestBroadcastedAtFromSongs < ActiveRecord::Migration[6.0]
  def change
    remove_column :songs, :latest_broadcasted_at, :datetime
  end
end
