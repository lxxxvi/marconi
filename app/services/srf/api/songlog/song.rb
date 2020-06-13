class Srf::Api::Songlog::Song
  def initialize(data)
    @data = data
  end

  def id
    @data['id']
  end

  def title
    @data['title']
  end

  def srf_api_songlog_artist
    @srf_api_songlog_artist ||= Srf::Api::Songlog::Artist.new(@data['Artist'])
  end

  def to_song
    @to_song ||= Song::Finders::Srf.find_or_initialize_by(self).tap do |song|
      song.artist = artist
    end
  end

  def artist
    @artist ||= srf_api_songlog_artist.to_artist
  end
end
