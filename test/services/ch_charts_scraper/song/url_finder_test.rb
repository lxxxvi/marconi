require 'test_helper'

class ChChartsScraper::Song::UrlFinderTest < ActiveSupport::TestCase
  test '#call' do
    stub_with_fixture(
      url: 'https://hitparade.ch/search.asp?artist=The%20Beatles&artist_search=starts&cat=s&from=&title=Yesterday&title_search=starts&to=',
      fixture: 'hitparade_ch/search_beatles_yesterday.html'
    )

    service = ChChartsScraper::Song::UrlFinder.new('The Beatles', 'Yesterday')
    assert_equal 'https://hitparade.ch/song/The-Beatles/Yesterday-11216', service.url
  end
end
