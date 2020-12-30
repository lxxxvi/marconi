require 'open-uri'

class Srf::Api::Request
  BASE_URL = 'https://www.srf.ch/songlog/log/channel'.freeze
  SRF3_CHANNEL_UUID = 'dd0fa1ba-4ff6-4e1a-ab74-d7e49057d96f'.freeze
  API_DATETIME_FORMAT = '%Y-%m-%dT%H:%M:%S'.freeze

  def initialize(from_time, to_time)
    @from_time = from_time
    @to_time = to_time
  end

  def call
    Srf::Api::Response.new(URI.parse(url).open.read)
  end

  def url
    "#{BASE_URL}/#{SRF3_CHANNEL_UUID}?#{get_params.to_param}"
  end

  private

  # rubocop:disable Naming/AccessorMethodName
  def get_params
    {
      fromDate: from_time_param,
      toDate: to_time_param
    }
  end
  # rubocop:enable Naming/AccessorMethodName

  def from_time_param
    to_api_datetime_string(@from_time)
  end

  def to_time_param
    to_api_datetime_string(@to_time)
  end

  def to_api_datetime_string(datetime)
    datetime.strftime(API_DATETIME_FORMAT)
  end
end
