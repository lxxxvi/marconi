class AddFirstBroadcastedAtToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :first_broadcasted_at, :datetime, null: true
  end
end
