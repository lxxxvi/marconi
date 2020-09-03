require 'test_helper'

class Facts::Artist::LatestBroadcastedAtCalculatorTest < ActiveSupport::TestCase
  test '#call!' do
    artist = artists(:beatles)
    station = stations(:srf3)

    reference_time = Time.utc(2044, 4, 4, 4, 4, 4)

    artist.songs.first.broadcasts.create!(station: station, broadcasted_at: reference_time)

    Facts::Artist::LatestBroadcastedAtCalculator.new.call!

    fact = artist.facts.find_or_initialize_by(key: :latest_broadcasted_at, station: station)

    assert_equal reference_time, fact.value
  end
end
