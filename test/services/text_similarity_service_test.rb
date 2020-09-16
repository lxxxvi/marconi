require 'test_helper'

class TextSimilarityServiceTest < ActiveSupport::TestCase
  test '.similarity' do
    assert_equal 0, TextSimilarityService.similarity('foo', 'bar')

    assert_in_delta 0.40,
                    0.05,
                    TextSimilarityService.similarity('The Roots feat. Cody ChesnuTT - The Seed (2.0)',
                                                     'The Roots - The Seed')

    assert_equal 1, TextSimilarityService.similarity('The Beatles - Yesterday', 'The Beatles Yesterday')
  end
end
