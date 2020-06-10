require 'test_helper'

class Srf::Api::Songlog::SongTest < ActiveSupport::TestCase
  test '.new' do
    srf_api_songlog_song.tap do |srf_api_song|
      assert_equal 'STRAWBERRY MOON', srf_api_song.title
      assert_equal 'SONG-ID', srf_api_song.id

      assert_equal 'Thurston Moore', srf_api_song.artist.name
    end
  end

  test '#to_song' do
    srf_api_songlog_song.to_song.tap do |song|
      assert_equal Song, song.class
      assert_equal 'STRAWBERRY MOON', song.title
      assert song.new_record?
    end
  end

  test '#artist' do
    srf_api_songlog_song.artist.tap do |artist|
      assert_equal Artist, artist.class
      assert_equal 'Thurston Moore', artist.name
      assert artist.new_record?
    end
  end

  private

  def srf_api_songlog_song
    Srf::Api::Songlog::Song.new(
      {
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
    )
  end
end
