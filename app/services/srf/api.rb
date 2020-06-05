require 'open-uri'

class Srf::Api
  def initialize(date = Date.today.yesterday)
    @date = date
    @from_time = date.at_beginnig_of_day
    @to_time = date.at_end_of_day
  end

  def call
    request = Request.new(@from_time, @to_time)
    @response = request.call
  end
end
