require 'test_helper'

class Facts::Artist::TotalBroadcastsCalculatorTest < ActiveSupport::TestCase
  test '#call!' do
    artist = artists(:beatles)
    song = songs(:beatles_help)
    station = stations(:srf3)

    song.broadcasts.create!(station: station, broadcasted_at: 1.second.ago, external_key: 'one-second-ago')
    song.broadcasts.create!(station: station, broadcasted_at: 2.seconds.ago, external_key: 'two-seconds-ago')

    Facts::Artist::TotalBroadcastsCalculator.new.call!

    song.reload

    fact = artist.facts.find_or_initialize_by(key: :total_broadcasts, station: station)
    assert_equal 3, fact.decorated_value
  end
end
