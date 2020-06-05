class Srf::Api::Response
  attr_reader :raw_data, :data

  def initialize(raw_data)
    @raw_data = raw_data
    @data = JSON.parse(raw_data)
  end

  def broadcasts
    @broadcasts ||= @data['Songlog'].map do |object|
      Srf::Broadcast.new(object)
    end
  end
end
