class Srf::Api
  attr_reader :request

  def initialize(date)
    @request = Srf::Api::Request.new(date.at_beginning_of_day, date.at_end_of_day)
  end

  def call
    @request.call
  end
end
