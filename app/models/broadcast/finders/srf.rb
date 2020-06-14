class Broadcast::Finders::Srf
  def initialize(srf_api_songlog_broadcast)
    @srf_api_songlog_broadcast = srf_api_songlog_broadcast
  end

  def self.find_or_initialize_by(srf_api_songlog_broadcast)
    new(srf_api_songlog_broadcast).find_or_initialize_broadcast
  end

  def srf3_station
    @srf3_station ||= Station.find_by!(name: 'SRF3')
  end

  def find_or_initialize_broadcast
    srf3_station.broadcasts
                .of_song(@srf_api_songlog_broadcast.song)
                .find_or_initialize_by(external_key: @srf_api_songlog_broadcast.id)
                .tap do |broadcast|
      broadcast.broadcasted_at = @srf_api_songlog_broadcast.broadcasted_at
    end
  end
end
