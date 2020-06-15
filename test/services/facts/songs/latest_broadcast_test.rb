require 'test_helper'

class Facts::Songs::LatestBroadcastTest < ActiveSupport::TestCase
  test '#call!' do
    song = songs(:beatles_yesterday)

    create_more_broadcasts!(song)

    assert_changes -> { song.latest_broadcasted_at },
                   to: Time.utc(2020, 6, 5, 16, 0, 0) do
      Facts::Songs::LatestBroadcast.call!
      song.reload
    end
  end

  def create_more_broadcasts!(song)
    latest_broadcast = song.broadcasts.ordered_chronologically.last

    10.times do |index|
      new_broadcast = latest_broadcast.dup
      new_broadcast.broadcasted_at -= (1 + index).days
      new_broadcast.external_key = "EXTERNAL-KEY-#{index}"
      new_broadcast.save!
    end
  end
end
