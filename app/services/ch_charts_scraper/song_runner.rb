class ChChartsScraper::SongRunner
  def initialize(duration = 1.hour)
    @stop_scraping_at = duration.from_now
  end

  def call!
    Rails.logger.info("Going to scrape until #{@stop_scraping_at.inspect}")

    scrape_new_songs
    rescrape_url_not_found_songs

    Rails.logger.info('Goodbye.')
  end

  private

  def scrape_new_songs
    process_songs(new_songs, 'New Songs')
  end

  def rescrape_url_not_found_songs
    process_songs(url_not_found_songs, 'URL not found Songs')
  end

  def process_songs(songs_scope, scope_name)
    Rails.logger.info("Song scope: #{pink(scope_name)}")
    songs_scope.each do |song|
      break if @stop_scraping_at.past?

      scrape_song(song)
      catch_a_breath
    end
  end

  def scrape_song(song)
    Rails.logger.info("Scraping #{green(song.decorate.artist_with_song)}")
    scraper = ChChartsScraper::Song.new(song)
    scraper.call!
    Rails.logger.info("   => Status: #{scraper.song_ch_charts_scraper_status}")
  end

  def catch_a_breath
    sleep_time = random_sleep_time
    Rails.logger.info(gray("Catching a breath for #{sleep_time} seconds..."))
    sleep sleep_time unless Rails.env.test?
  end

  def green(text)
    "\e[32m#{text}\e[0m"
  end

  def gray(text)
    "\e[90m#{text}\e[0m"
  end

  def pink(text)
    "\e[95m#{text}\e[0m"
  end

  def random_sleep_time
    (([1, 2, 3].sample * [2, 3, 4].sample) / 2.0)
  end

  def new_songs
    enabled_songs.ch_charts_scraper_status_new.order(created_at: :asc)
  end

  def url_not_found_songs
    enabled_songs.ch_charts_scraper_status_url_not_found.order(ch_charts_scraper_status_updated_at: :asc)
  end

  def enabled_songs
    Song.ch_charts_scraper_enabled
  end
end
