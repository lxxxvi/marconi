class AddIndexOnPredictionsReferenceDate < ActiveRecord::Migration[6.0]
  def change
    add_index :predictions, :reference_date
  end
end
