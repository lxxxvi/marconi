require 'test_helper'

class Srf::Api::Songlog::SongTest < ActiveSupport::TestCase
  test '.new' do
    Srf::Api::Songlog::Song.new(example_srf_api_song_hash).tap do |srf_api_song|
      assert_equal 'STRAWBERRY MOON', srf_api_song.title
      assert_equal 'SONG-ID', srf_api_song.id

      assert_equal 'Thurston Moore', srf_api_song.artist.name
    end
  end

  test '#to_song' do
    assert false
  end

  private

  def example_srf_api_song_hash
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
  end
end
