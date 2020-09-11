require 'test_helper'

class Google::SearchResultScraperTest < ActiveSupport::TestCase
  test '#search_result_links' do
    stub_the_roots

    service = Google::SearchResultScraper.new('The Roots The Seed (2.0)')

    first_link = service.search_result_links.first
    assert_equal 'https://hitparade.ch/song/The-Roots-feat.-Cody-ChesnuTT/The-Seed-(2.0)-5597', first_link
  end

  private

  def stub_the_roots
    stub_request(
      :get,
      'https://www.google.ch/search?bih=&biw=&btnG=Google%20Suche&gbv=1&hl=de-CH&q=The%20Roots%20The%20Seed%20(2.0)&source=hp'
    ).with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Ruby'
      }
    ).to_return(status: 200, body: file_fixture('google/search_response_the_roots.html'), headers: {})
  end
end
