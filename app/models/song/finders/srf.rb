class Song::Finders::Srf
  def initialize(srf_api_songlog_song)
    @srf_api_songlog_song = srf_api_songlog_song
  end

  def self.find_or_initialize_by(srf_api_songlog_song)
    new(srf_api_songlog_song).find_or_initialize
  end

  def find_or_initialize
    return find_external_key.externally_identifyable if find_external_key.present?

    song_with_new_external_key
  end

  def srf3_station
    @srf3_station ||= Station.find_by!(name: 'SRF3')
  end

  def find_external_key
    @find_external_key ||= ExternalKey.songs
                                      .of_station(srf3_station)
                                      .find_by(identifier: @srf_api_songlog_song.id)
  end

  def song_with_new_external_key
    @srf_api_songlog_song.artist.songs.find_or_initialize_by(title: @srf_api_songlog_song.title).tap do |song|
      song.external_keys.new(identifier: @srf_api_songlog_song.id)
    end
  end
end
