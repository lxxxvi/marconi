require 'test_helper'

class Facts::Artist::FirstBroadcastedAtCalculatorTest < ActiveSupport::TestCase
  test '#call!' do
    artist = artists(:beatles)
    station = stations(:srf3)

    reference_time = Time.utc(2020, 1, 4, 5, 6, 7)

    artist.songs.first.broadcasts.create!(station: station, broadcasted_at: reference_time)

    Facts::Artist::FirstBroadcastedAtCalculator.new.call!

    fact = artist.facts.find_or_initialize_by(key: :first_broadcasted_at, station: station)
    assert_equal reference_time, fact.decorated_value
  end
end
