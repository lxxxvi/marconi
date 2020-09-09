class AddChChartsScraperColumnsToSong < ActiveRecord::Migration[6.0]
  def change
    change_table :songs, bulk: true do |t|
      t.boolean :ch_charts_scraper_enabled, null: false, default: true
      t.string :ch_charts_scraper_url, null: true
      t.string :ch_charts_scraper_status, null: true
      t.timestamp :ch_charts_scraper_status_updated_at, null: true
    end
  end
end
