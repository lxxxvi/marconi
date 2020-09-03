require 'test_helper'

class CachedFactsTableCreatorTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test '#create! Song' do
    song = songs(:beatles_yesterday)
    station = stations(:srf3)

    service = CachedFactsTableCreator.new(Song)
    service.create!

    facts = song.cached_facts_on_station(station)
    assert_equal Time.utc(2020, 6, 5, 16, 0, 0), facts.first_broadcasted_at
  end

  test '#create! Artist' do
    artist = artists(:beatles)
    station = stations(:srf3)

    service = CachedFactsTableCreator.new(Artist)
    service.create!

    facts = artist.cached_facts_on_station(station)
    assert_equal '1', facts.total_broadcasts
  end
end
