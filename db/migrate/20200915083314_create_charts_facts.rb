class CreateChartsFacts < ActiveRecord::Migration[6.0]
  def change
    create_table :charts_facts do |t|
      t.string :country, null: false
      t.references :factable, polymorphic: true, null: false
      t.string :key, null: false
      t.string :value, null: false

      t.index %i[country factable_type factable_id key], unique: true, name: :indx_country_factable_key

      t.timestamps
    end
  end
end
