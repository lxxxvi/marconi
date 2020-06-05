require 'test_helper'

class Srf::BroadcastTest < ActiveSupport::TestCase
  test 'parses the input' do
    Srf::Broadcast.new(api_object).tap do |broadcast|
      assert_equal 'BROADCAST-ID', broadcast.broadcast_id
      assert_equal DateTime.new(2020, 6, 4, 23, 54, 14, '+02:00'), broadcast.broadcasted_at

      assert_equal 'SONG-ID', broadcast.song_id
      assert_equal 'STRAWBERRY MOON', broadcast.song_title

      assert_equal 'ARTIST-ID', broadcast.artist_id
      assert_equal 'Thurston Moore', broadcast.artist_name
    end
  end

  private

  def api_object
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
  end
end
