class SongDecorator < BaseDecorator
  def artist_with_song
    "#{artist.name} - #{title}"
  end
end
