namespace :ch_charts_scraper do
  desc 'Scrape CH charts song table'
  task scrape_songs: :environment do
    Rails.logger.level = :info
    ChChartsScraper::SongRunner.new.call!
  end
end
