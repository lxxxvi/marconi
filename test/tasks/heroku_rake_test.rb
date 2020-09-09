require 'test_helper'
require 'rake'

class HerokuRakeTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
  end

  test 'it does not raise' do
    stub_srf3

    assert Rake::Task['heroku:daily'].invoke
  end

  private

  def stub_srf3
    stub_request(
      :get,
      %r{https://www.srf.ch/songlog/.*}
    ).with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Ruby'
      }
    ).to_return(status: 200, body: file_fixture('srf/api_response_songlog_20200605.json'), headers: {})
  end
end
