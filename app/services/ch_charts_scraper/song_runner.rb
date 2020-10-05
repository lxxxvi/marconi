class ChChartsScraper::SongRunner
  def initialize(duration = 1.hour)
    @stop_scraping_at = duration.from_now
  end

  def call!
    Rails.logger.info("Going to scrape until #{@stop_scraping_at.inspect}")
    do_the_work(new_songs, 'New Songs')

    Rails.logger.info('Goodbye.')
  end

  private

  def do_the_work(songs_scope, scope_name)
    Rails.logger.info("Song scope: #{pink(scope_name)}")
    songs_scope.each do |song|
      break if @stop_scraping_at.past?

      Rails.logger.info("Scraping #{green(song.decorate.artist_with_song)}")
      ChChartsScraper::Song.new(song).call!
      catch_a_breath
    end
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
    Song.ch_charts_scraper_enabled
        .ch_charts_scraper_status_new
  end
end
