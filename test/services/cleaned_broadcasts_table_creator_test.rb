require 'test_helper'

class CleanedBroadcastsTableCreatorTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test 'create!' do
    song = songs(:beatles_yesterday)
    broadcast = broadcasts(:yesterday_20200605_broadcast)
    station = stations(:srf3)

    Broadcast.where.not(song: song).where.not(station: station).delete_all

    broadcast.update!(broadcasted_at: '2020-01-01')

    duplicate_broadcast!(broadcast, 1.day)
    duplicate_broadcast!(broadcast, 2.days)

    CleanedBroadcastsTableCreator.create!

    broadcasts = CleanedBroadcast.chronologically

    assert_equal 3, broadcasts.count

    broadcasts.first.tap do |first_broadcast|
      assert_equal Time.utc(2020, 1, 1), first_broadcast.broadcasted_at
      assert_nil first_broadcast.previous_broadcasted_at
      assert_equal Time.utc(2020, 1, 2), first_broadcast.next_broadcasted_at
    end

    broadcasts.second.tap do |second_broadcast|
      assert_equal Time.utc(2020, 1, 2), second_broadcast.broadcasted_at
      assert_equal Time.utc(2020, 1, 1), second_broadcast.previous_broadcasted_at
      assert_equal Time.utc(2020, 1, 3), second_broadcast.next_broadcasted_at
    end

    broadcasts.third.tap do |third_broadcast|
      assert_equal Time.utc(2020, 1, 3), third_broadcast.broadcasted_at
      assert_equal Time.utc(2020, 1, 2), third_broadcast.previous_broadcasted_at
      assert_nil third_broadcast.next_broadcasted_at
    end
  end

  private

  def duplicate_broadcast!(broadcast, broadcasted_at_increment)
    broadcast.dup.tap do |new_broadcast|
      new_broadcast.broadcasted_at += broadcasted_at_increment
      new_broadcast.external_key = "+ #{broadcasted_at_increment}"
      new_broadcast.save!
    end
  end
end
