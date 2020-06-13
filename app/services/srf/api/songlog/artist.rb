class Srf::Api::Songlog::Artist
  def initialize(data)
    @data = data
  end

  def id
    @id = @data['id']
  end

  def name
    @name = @data['name']
  end

  def to_artist
    @to_artist ||= Artist::Finders::Srf.find_or_initialize_by(self)
  end
end
