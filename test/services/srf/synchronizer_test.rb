require 'test_helper'

class Srf::SynchronizerTest < ActiveSupport::TestCase
  test '#synchronize!' do
    srf_songlog_stub

    Srf::Synchronizer.new(Date.new(2020, 6, 5)).tap do |service|
      assert_difference [-> { Broadcast.count }, -> { Song.count }, -> { Artist.count }], 1 do
        service.synchronize!
        assert_equal 2, service.srf_api_broadcasts.size
        assert_equal Srf::Api::Songlog::Broadcast, service.srf_api_broadcasts.first.class
      end
    end
  end

  private

  # rubocop:disable Metrics/MethodLength
  def srf_songlog_stub
    stub_request(
      :get,
      'https://www.srf.ch/songlog/log/channel/dd0fa1ba-4ff6-4e1a-ab74-d7e49057d96f?fromDate=2020-06-05T00:00:00&toDate=2020-06-05T23:59:59'
    ).with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Ruby'
      }
    ).to_return(
      status: 200,
      body: file_fixture('srf/api_response_songlog_20200605.json'),
      headers: {}
    )
  end
  # rubocop:enable Metrics/MethodLength
end
