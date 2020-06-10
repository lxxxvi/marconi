class Srf::Api::Songlog::Song
  attr_reader :id, :title, :srf_api_songlog_artist

  def initialize(hash)
    @id = hash['id']
    @title = hash['title']
    @srf_api_songlog_artist = Srf::Api::Songlog::Artist.new(hash['Artist'])
  end

  def to_song
    @to_song ||= Song::Finders::Srf.find_or_initialize_by(self)
  end

  def artist
    @artist ||= @srf_api_songlog_artist.to_artist
  end
end
