require 'test_helper'

class BroadcastTest < ActiveSupport::TestCase
  test '#save' do
    broadcast = Broadcast.new

    assert_changes -> { broadcast.save }, to: true do
      broadcast.song = songs(:beatles_yesterday)
      broadcast.station = stations(:srf3)
      broadcast.broadcasted_at = Time.zone.now
    end
  end
end
