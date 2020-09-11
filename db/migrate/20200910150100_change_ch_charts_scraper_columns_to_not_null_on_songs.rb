class ChangeChChartsScraperColumnsToNotNullOnSongs < ActiveRecord::Migration[6.0]
  def change
    change_column_null :songs, :ch_charts_scraper_status, false
    change_column_null :songs, :ch_charts_scraper_status_updated_at, false
  end
end
