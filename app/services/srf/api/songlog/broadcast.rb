class Srf::Api::Songlog::Broadcast
  def initialize(data)
    @data = data
  end

  def id
    @data['id']
  end

  def broadcasted_at
    @broadcasted_at ||= DateTime.iso8601(@data['playedDate'])
  end

  def srf_api_songlog_song
    @srf_api_songlog_song ||= Srf::Api::Songlog::Song.new(@data['Song'])
  end

  def to_broadcast
    @to_broadcast ||= Broadcast::Finders::Srf.find_or_initialize_by(self)
  end

  def song
    @song ||= srf_api_songlog_song.to_song
  end
end
