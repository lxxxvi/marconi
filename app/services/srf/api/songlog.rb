class Srf::Api::Songlog
  def initialize(songlog)
    @songlog = songlog
  end

  def broadcasts
    @broadcasts ||= @songlog.map(&method(:to_songlog_broadcast))
  end

  private

  def to_songlog_broadcast(broadcast)
    Srf::Api::Songlog::Broadcast.new(broadcast)
  end
end
