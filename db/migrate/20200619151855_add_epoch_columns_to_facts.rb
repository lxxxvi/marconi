class AddEpochColumnsToFacts < ActiveRecord::Migration[6.0]
  def change
    change_table :facts, bulk: true do |t|
      t.column :epoch_year, :bigint, null: false, default: 0
      t.column :epoch_week, :bigint, null: false, default: 0
    end
  end
end
