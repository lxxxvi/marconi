class Srf::Broadcast

  def initialize(api_object)
    @api_object ||= api_object
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
    @broadcast ||= @api_object
  end

  def song
    @song ||= broadcast&.dig('Song')
  end

  def artist
    @artist ||= song&.dig('Artist')
  end
end
