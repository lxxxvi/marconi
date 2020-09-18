class ChChartsScraper::SongRunner
  def initialize(duration = 1.hour)
    @stop_scraping_at = duration.from_now
  end

  def call!
    Rails.logger.info("Going to scrape until #{@stop_scraping_at.inspect}")
    ordered_srf3songs.each do |song|
      break if @stop_scraping_at.past?

      do_the_work(song)
      catch_a_breath
    end

    Rails.logger.info('Goodbye.')
  end

  private

  def do_the_work(song)
    Rails.logger.info("Scraping #{green(song.decorate.artist_with_song)}")
    ChChartsScraper::Song.new(song).call!
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

  def random_sleep_time
    (([1, 2, 3].sample * [2, 3, 4].sample) / 2.0)
  end

  # simplify this as soon as the majority of songs URL have been found
  def ordered_srf3songs
    Song.ch_charts_scraper_enabled
        .where(ch_charts_scraper_status: %i[outdated new])
        .left_outer_joins(:facts)
        .joins(:artist).includes(:artist)
        .where(facts: { station: Station.find_by!(name: 'SRF3'), key: :total_broadcasts })
        .order(Arel.sql('CAST(facts.value AS INT) DESC'))
  end
end
