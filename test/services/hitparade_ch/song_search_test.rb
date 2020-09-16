require 'test_helper'

class HitparadeCh::SongSearchTest < ActiveSupport::TestCase
  test '#search_result_links' do
    stub_with_fixture(
      url: 'https://hitparade.ch/search.asp?cat=s&from=&to=&artist=RED+HOT+CHILI+PEPPERS&artist_search=starts&title=DANI+CALIFORNIA&title_search=starts',
      fixture: 'hitparade_ch/search_red_hot_chili_peppers_dani_california.html'
    )

    service = HitparadeCh::SongSearch.new('RED HOT CHILI PEPPERS', 'DANI CALIFORNIA')

    assert_equal 'https://hitparade.ch/song/Red-Hot-Chili-Peppers/Dani-California-197159',
                 service.search_result_links.first
  end
end
