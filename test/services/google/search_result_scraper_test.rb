require 'test_helper'

class Google::SearchResultScraperTest < ActiveSupport::TestCase
  test '#search_result_links' do
    stub_with_fixture(
      url: 'https://www.google.ch/search?bih=&biw=&btnG=Google%20Suche&gbv=1&hl=de-CH&q=The%20Roots%20The%20Seed%20(2.0)&source=hp',
      fixture: 'google/the_roots_the_seed.html'
    )

    service = Google::SearchResultScraper.new('The Roots The Seed (2.0)')

    first_link = service.search_result_links.first
    assert_equal 'https://www.youtube.com/watch?v=ojC0mg2hJCc', first_link
  end
end
