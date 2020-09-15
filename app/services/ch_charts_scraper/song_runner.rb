class ChChartsScraper::SongRunner
  def call!
    ordered_srf3songs.each do |song|
      ChChartsScraper::Song.new(song).call!

      Rails.logger.info('Catching a breath...')
      sleep 5 unless Rails.env.test?
    end
  end

  private

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
