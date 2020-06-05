class Srf::Api::Songlog::Item
  def initialize(songlog_item)
    @songlog_item ||= songlog_item
  end

  def broadcast_id
    broadcast['id']
  end

  def broadcasted_at
    DateTime.iso8601(broadcast['playedDate'])
  end

  def song_id
    song['id']
  end

  def song_title
    song['title']
  end

  def artist_id
    artist['id']
  end

  def artist_name
    artist['name']
  end

  private

  def broadcast
    @broadcast ||= @songlog_item
  end

  def song
    @song ||= broadcast&.dig('Song')
  end

  def artist
    @artist ||= song&.dig('Artist')
  end
end
