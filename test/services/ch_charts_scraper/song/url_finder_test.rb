require 'test_helper'

class ChChartsScraper::Song::UrlFinderTest < ActiveSupport::TestCase
  test '#call' do
    stub_with_fixture(
      url: 'https://hitparade.ch/search.asp?artist=The%20Beatles&artist_search=starts&cat=s&from=&title=Yesterday&title_search=starts&to=',
      fixture: 'hitparade_ch/search_beatles_yesterday.html'
    )

    song = songs(:beatles_yesterday)

    service = ChChartsScraper::Song::UrlFinder.new(song)
    assert_equal 'https://hitparade.ch/song/The-Beatles/Yesterday-11216', service.url
  end
end
