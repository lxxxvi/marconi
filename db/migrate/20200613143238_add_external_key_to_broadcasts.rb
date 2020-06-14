class AddExternalKeyToBroadcasts < ActiveRecord::Migration[6.0]
  def change
    add_column :broadcasts, :external_key, :string
  end
end
