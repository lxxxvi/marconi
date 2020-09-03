require 'test_helper'

class AverageSecondsBetweenBroadcastsCalculatorTest < ActiveSupport::TestCase
  test '#call!' do
    song1 = songs(:beatles_yesterday)
    song2 = songs(:beatles_help)

    artist = artists(:beatles)
    station = stations(:srf3)

    song1.broadcasts.delete_all
    song2.broadcasts.delete_all

    create_broadcast(song1, station, '2020-01-01 01:00:00 +00:00')
    create_broadcast(song2, station, '2020-01-01 02:00:00 +00:00') # 60 minutes later
    create_broadcast(song1, station, '2020-01-01 04:00:00 +00:00') # 120 minutes later (= ~ 90 minutes average)

    travel_to Time.utc(2020, 1, 1, 4, 0, 1) do
      Facts::Song::FirstBroadcastedAtCalculator.new.call!
      Facts::Song::TotalBroadcastsCalculator.new.call!

      Facts::Artist::FirstBroadcastedAtCalculator.new.call!
      Facts::Artist::TotalBroadcastsCalculator.new.call!

      Facts::Artist::AverageSecondsBetweenBroadcastsCalculator.new.call!
    end

    fact = artist.facts.find_or_initialize_by(key: :average_seconds_between_broadcasts, station: station)

    assert_equal 90.minutes.to_i, fact.decorate.value
  end

  private

  def create_broadcast(song, station, time)
    external_key = "#{song.id}-#{station.id}-#{time}"
    song.broadcasts.create!(station: station, broadcasted_at: time, external_key: external_key)
  end
end
