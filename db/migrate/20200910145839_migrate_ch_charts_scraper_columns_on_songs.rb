class MigrateChChartsScraperColumnsOnSongs < ActiveRecord::Migration[6.0]
  def up
    ActiveRecord::Base.connection.execute(migration_sql)
  end

  private

  def migration_sql
    <<~SQL.squish
      UPDATE songs
         SET ch_charts_scraper_status = 'new'
           , ch_charts_scraper_status_updated_at = NOW()
       WHERE ch_charts_scraper_status IS NULL
    SQL
  end
end
