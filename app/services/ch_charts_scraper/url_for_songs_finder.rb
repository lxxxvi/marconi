class ChChartsScraper::UrlForSongsFinder
  def call
    Rails.logger.info('URL for Songs finder')

    ordered_srf3songs.each do |song|
      url = first_google_result_link("#{song.artist.name} #{song.title}")
      update_ch_charts_scraper_url_and_status!(song, url)

      sleep 1 unless Rails.env.test?
    end
  end

  private

  def update_ch_charts_scraper_url_and_status!(song, url)
    song.ch_charts_scraper_url = url
    song.ch_charts_scraper_status = url.present? ? 'outdated' : 'url_not_found'
    song.ch_charts_scraper_status_updated_at = Time.zone.now
    song.save!
  end

  def ordered_srf3songs
    Song.ch_charts_scraper_status_new
        .ch_charts_scraper_enabled
        .left_outer_joins(:facts)
        .joins(:artist).includes(:artist)
        .where(facts: { station: Station.find_by!(name: 'SRF3'), key: :total_broadcasts })
        .order(Arel.sql('CAST(facts.value AS INT) DESC'))
  end

  def first_google_result_link(query)
    google_api = Google::SearchResultScraper.new(query)
    Rails.logger.info("URL: #{google_api.query_url}")

    google_api.search_result_links.first
  end
end
