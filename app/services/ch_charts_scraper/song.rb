class ChChartsScraper::Song
  SIMILARITY_THRESHOLD = 0.35

  def initialize(song)
    @song = song
  end

  def call!
    find_song_url!

    return nil if @song.ch_charts_scraper_status_url_not_found?
    return store_chart_facts! if song_pages_artist_with_song_similar_enough?

    mark_as_incorrect_url!
  end

  private

  def find_song_url!
    return if @song.ch_charts_scraper_url.present?

    url = ChChartsScraper::Song::UrlFinder.new(@song).url

    @song.ch_charts_scraper_url = url
    @song.ch_charts_scraper_status = url.present? ? 'outdated' : 'url_not_found'
    @song.ch_charts_scraper_status_updated_at = Time.zone.now
    @song.save!
  end

  def song_pages_artist_with_song_similar_enough?
    TextSimilarityService.similarity(song_page.artist_with_song, @song.decorate.artist_with_song) > SIMILARITY_THRESHOLD
  end

  def song_page
    @song_page ||= ChChartsScraper::Song::Page.new(@song.ch_charts_scraper_url)
  end

  def store_chart_facts!
    Song.transaction do
      song_page.chart_facts.each(&method(:store_chart_fact!))

      @song.year = song_page.song_year
      @song.ch_charts_scraper_status = 'updated'
      @song.ch_charts_scraper_status_updated_at = Time.zone.now
      @song.save!
    end
  end

  def store_chart_fact!(hash)
    key, value = hash

    return if value.nil?

    chart_fact = @song.charts_fact('CH', key)
    chart_fact.value = value
    chart_fact.save!
  end

  def mark_as_incorrect_url!
    @song.ch_charts_scraper_status = 'incorrect_url'
    @song.ch_charts_scraper_status_updated_at = Time.zone.now
    @song.save!
  end
end
