class ChChartsScraper::Song::UrlFinder
  def initialize(song)
    @song = song
  end

  def url
    first_song_link
  end

  private

  def first_song_link
    search_result_links.find { _1.match(%r{^https://hitparade.ch/song/}) }
  end

  def search_result_links
    @search_result_links ||= search_service.search_result_links
  end

  def search_service
    HitparadeCh::SongSearch.new(@song.artist.name, @song.title)
  end

  # temporarily unused:
  # google_search_query = "#{@song.decorate.artist_with_song} site:hitparade.ch/song"
  # Google::SearchResultScraper.new(google_search_query)
end
