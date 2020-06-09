class Srf::Api::Artist
  attr_reader :id, :name

  def initialize(hash)
    @id = hash['id']
    @name = hash['name']
  end

  def to_artist
    @to_artist ||= Artist::Finders::Srf.find_or_initialize_by(self)
  end
end
