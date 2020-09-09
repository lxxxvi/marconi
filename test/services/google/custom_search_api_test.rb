require 'test_helper'

class Google::CustomSearchApiTest < ActiveSupport::TestCase
  test '#search_result' do
    service = Google::CustomSearchApi.new('The Roots The Seed (2.0)')

    service.search_result.tap do |search_result|
      assert_equal 1, search_result.count

      top_result = search_result.first

      assert_equal 'The Roots feat. Cody ChesnuTT - The Seed (2.0) - hitparade.ch',
                   top_result[:title]

      assert_equal 'https://hitparade.ch/song/The-Roots-feat.-Cody-ChesnuTT/The-Seed-(2.0)-5597',
                   top_result[:link]
    end

    assert false, 'todo'
  end
end
