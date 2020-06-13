require 'test_helper'

class Srf::Api::Songlog::BroadcastTest < ActiveSupport::TestCase
  test '.new' do
    create_srf_api_songlog_broadcast.tap do |srf_api_songlog_broadcast|
      assert_equal 'BROADCAST-ID', srf_api_songlog_broadcast.id
      assert_equal DateTime.new(2020, 6, 4, 23, 54, 14, '+02:00'), srf_api_songlog_broadcast.broadcasted_at

      assert_equal 'STRAWBERRY MOON', srf_api_songlog_broadcast.song.title
      assert_equal 'Thurston Moore', srf_api_songlog_broadcast.song.artist.name
    end
  end

  test '#to_broadcast' do
    create_srf_api_songlog_broadcast.to_broadcast.tap do |broadcast|
      assert_equal Broadcast, broadcast.class
      assert_equal DateTime.new(2020, 6, 4, 23, 54, 14, '+02:00'), broadcast.broadcasted_at
      assert broadcast.new_record?
    end
  end

  test '#song' do
    create_srf_api_songlog_broadcast.song.tap do |song|
      assert_equal Song, song.class
      assert_equal 'STRAWBERRY MOON', song.title
      assert song.new_record?
    end
  end

  test '#save!' do
    create_srf_api_songlog_broadcast.tap do |srf_api_songlog_broadcast|
      assert_difference [-> { Broadcast.count }, -> { Song.count }, -> { Artist.count }], 1 do
        srf_api_songlog_broadcast.save!
      end
    end
  end

  private

  def create_srf_api_songlog_broadcast
    Srf::Api::Songlog::Broadcast.new(
      srf_api_response('srf/api_response_broadcast.json')
    )
  end
end
