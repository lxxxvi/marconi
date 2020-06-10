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

  private

  def create_srf_api_songlog_broadcast
    Srf::Api::Songlog::Broadcast.new(
      {
        "id" => "BROADCAST-ID",
        "channelId" => "CHANNEL-ID",
        "playedDate" => "2020-06-04T23:54:14+02:00",
        "isPlaying" => false,
        "Song" => {
            "title" => "STRAWBERRY MOON",
            "Artist" => {
              "name" => "Thurston Moore",
              "id" => "ARTIST-ID",
              "modifiedDate" => "2013-02-14T15:50:26+01:00",
              "createdDate" => "2011-03-24T22:48:14+01:00"
            },
            "id" => "SONG-ID",
            "modifiedDate" => "2020-06-04T23:54:14+02:00",
            "createdDate" => "2020-06-04T23:54:14+02:00"
        }
      }
    )
  end
end
