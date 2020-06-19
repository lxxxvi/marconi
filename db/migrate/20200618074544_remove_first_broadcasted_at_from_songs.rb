class RemoveFirstBroadcastedAtFromSongs < ActiveRecord::Migration[6.0]
  def change
    remove_column :songs, :first_broadcasted_at, :datetime
  end
end
