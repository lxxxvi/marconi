require 'test_helper'

class Google::CustomSearchApiTest < ActiveSupport::TestCase
  test '#search_result' do
    stub_the_roots

    service = Google::CustomSearchApi.new('The Roots The Seed (2.0)')

    service.search_result_items.tap do |search_result_items|
      assert_equal 1, search_result_items.count

      top_result = search_result_items.first

      assert_equal 'The Roots feat. Cody ChesnuTT - The Seed (2.0) - hitparade.ch',
                   top_result['title']

      assert_equal 'https://hitparade.ch/song/The-Roots-feat.-Cody-ChesnuTT/The-Seed-(2.0)-5597',
                   top_result['link']
    end
  end

  private

  def stub_the_roots
    stub_request(
      :get,
      'https://www.googleapis.com/customsearch/v1?cx=a585049f35d8e28ca&key=google-custom-search-fake-api-key&num=1&q=The%20Roots%20The%20Seed%20(2.0)&siteSearch=hitparade.ch/song&siteSearchFilter=i'
    ).with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Ruby'
      }
    ).to_return(status: 200, body: file_fixture('google/api_response_the_roots.json'), headers: {})
  end
end
