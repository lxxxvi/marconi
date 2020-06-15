require 'test_helper'

class Facts::Songs::TotalBroacastsFactTest < ActiveSupport::TestCase
  test '#call!' do
    song = songs(:beatles_yesterday)

    assert_difference -> { total_broadcasts_for_song(song) }, +10 do
      create_more_broadcasts!(song)
    end
  end

  private

  def total_broadcasts_for_song(song)
    Facts::Songs::TotalBroadcasts.call!
    song.reload.total_broadcasts
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
