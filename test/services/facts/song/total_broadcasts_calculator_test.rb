require 'test_helper'

class Facts::Song::TotalBroacastsCalculatorTest < ActiveSupport::TestCase
  test '#call!' do
    song = songs(:beatles_yesterday)
    station = stations(:srf3)

    assert_changes -> { total_broadcasts_for_song(song, station) }, from: 1, to: 3 do
      create_more_broadcasts!(song)
      Facts::Song::TotalBroadcastsCalculator.new.call!
    end
  end

  private

  def total_broadcasts_for_song(song, station)
    song.facts.find_or_initialize_by(key: :total_broadcasts, station: station).decorated_value
  end

  def create_more_broadcasts!(song)
    first_broadcast = song.broadcasts.ordered_chronologically.first

    2.times do |index|
      new_broadcast = first_broadcast.dup
      new_broadcast.broadcasted_at += (1 + index).days
      new_broadcast.external_key = "EXTERNAL-KEY-#{index}"
      new_broadcast.save!
    end
  end
end
