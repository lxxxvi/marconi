require 'test_helper'

class Srf::Api::Songlog::ItemTest < ActiveSupport::TestCase
  test 'parses the input' do
    Srf::Api::Songlog::Item.new(example_songlog_item).tap do |songlog_item|
      assert_equal 'BROADCAST-ID', songlog_item.broadcast_id
      assert_equal DateTime.new(2020, 6, 4, 23, 54, 14, '+02:00'), songlog_item.broadcasted_at

      assert_equal 'SONG-ID', songlog_item.song_id
      assert_equal 'STRAWBERRY MOON', songlog_item.song_title

      assert_equal 'ARTIST-ID', songlog_item.artist_id
      assert_equal 'Thurston Moore', songlog_item.artist_name
    end
  end

  private

  def example_songlog_item
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
