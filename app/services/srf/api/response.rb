class Srf::Api::Response
  attr_reader :raw_data, :data

  def initialize(raw_data)
    @raw_data = raw_data
    @data = JSON.parse(raw_data)
  end

  def songlog
    @songlog ||= Srf::Api::Songlog.new(@data['Songlog'])
  end
end
