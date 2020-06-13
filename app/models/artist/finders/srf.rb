class Artist::Finders::Srf
  def initialize(srf_api_songlog_artist)
    @srf_api_songlog_artist = srf_api_songlog_artist
  end

  def self.find_or_initialize_by(srf_api_songlog_artist)
    new(srf_api_songlog_artist).find_or_initialize
  end

  def find_or_initialize
    return find_external_key.externally_identifyable if find_external_key.present?

    artist_with_new_external_key
  end

  def srf3_station
    @srf3_station ||= Station.find_by!(name: 'SRF3')
  end

  def find_external_key
    @find_external_key ||= ExternalKey.artists
                                      .of_station(srf3_station)
                                      .find_by(identifier: @srf_api_songlog_artist.id)
  end

  def artist_with_new_external_key
    Artist.find_or_initialize_by(name: @srf_api_songlog_artist.name).tap do |artist|
      artist.external_keys.new(
        station: @srf3_station,
        identifier: @srf_api_songlog_artist.id
      )
    end
  end
end
