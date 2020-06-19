require 'test_helper'

class Facts::Song::FirstBroadcastedAtCalculatorTest < ActiveSupport::TestCase
  test '#call!' do
    song = songs(:beatles_yesterday)
    station = stations(:srf3)

    facts(:beatles_yesterday_first_broadcasted_at_fact_srf3).destroy

    create_more_broadcasts!(song)

    assert_changes -> { first_broadcasted_at(song, station) },
                   to: Time.utc(2020, 6, 5, 16, 0, 0) do
      Facts::Song::FirstBroadcastedAtCalculator.new.call!
      song.reload
    end
  end

  private

  def first_broadcasted_at(song, station)
    song.facts.find_or_initialize_by(key: :first_broadcasted_at, station: station).decorated_value
  end

  def create_more_broadcasts!(song)
    first_broadcast = song.broadcasts.ordered_chronologically.first

    10.times do |index|
      new_broadcast = first_broadcast.dup
      new_broadcast.broadcasted_at += (1 + index).days
      new_broadcast.external_key = "EXTERNAL-KEY-#{index}"
      new_broadcast.save!
    end
  end
end
