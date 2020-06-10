class Broadcast::Finders::Srf
  def initialize(srf_api_songlog_broadcast)
    @srf_api_songlog_broadcast = srf_api_songlog_broadcast
  end

  def self.find_or_initialize_by(srf_api_songlog_broadcast)
    new(srf_api_songlog_broadcast).find_or_initialize
  end

  def find_or_initialize
    return find_external_key.externally_identifyable if find_external_key.present?

    broadcast_with_new_external_key
  end

  def srf3_station
    @srf3_station ||= Station.find_by!(name: 'SRF3')
  end

  def find_external_key
    @find_external_key ||= ExternalKey.broadcasts
                                      .of_station(srf3_station)
                                      .find_by(identifier: @srf_api_songlog_broadcast.id)
  end

  def broadcast_with_new_external_key
    srf3_station.broadcasts
                .of_song(@srf_api_songlog_broadcast.song)
                .broadcasted_at_around(@srf_api_songlog_broadcast.broadcasted_at)
                .first_or_initialize.tap do |broadcast|
      broadcast.broadcasted_at = @srf_api_songlog_broadcast.broadcasted_at
      broadcast.external_keys.new(identifier: @srf_api_songlog_broadcast.id)
    end
  end
end
