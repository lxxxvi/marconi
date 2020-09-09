require 'test_helper'

class ChChartsScraper::UrlForSongsFinderTest < ActiveSupport::TestCase
  test '#call' do
    yesterday_song, help_song = songs(:beatles_yesterday, :beatles_help)

    help_song.update!(ch_charts_scraper_enabled: false)
    assert_equal 'new', yesterday_song.ch_charts_scraper_status

    service = ChChartsScraper::UrlForSongsFinder.new
    reference_time = Time.utc(2020, 3, 3, 3, 3, 3)

    travel_to reference_time do
      stub_beatles_yesterday
      service.call

      yesterday_song.reload

      assert_equal reference_time, yesterday_song.ch_charts_scraper_status_updated_at
      assert_equal 'outdated', yesterday_song.ch_charts_scraper_status
      assert_equal 'https://hitparade.ch/song/The-Beatles/Yesterday-11216', yesterday_song.ch_charts_scraper_url
    end
  end

  private

  def stub_beatles_yesterday
    stub_request(
      :get,
      'https://www.google.ch/search?bih=&biw=&btnG=Google%20Suche&gbv=1&hl=de-CH&q=The%20Beatles%20Yesterday&source=hp'
    ).with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Ruby'
      }
    ).to_return(status: 200, body: file_fixture('google/search_response_beatles_yesterday.html'), headers: {})
  end
end
