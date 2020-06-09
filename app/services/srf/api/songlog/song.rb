class Srf::Api::Songlog::Song
  attr_reader :id, :title, :artist

  def initialize(hash)
    @id = hash['id']
    @title = hash['title']
    @artist = Srf::Api::Songlog::Artist.new(hash['Artist'])
  end

  def to_song
    raise 'todo'
  end
end
