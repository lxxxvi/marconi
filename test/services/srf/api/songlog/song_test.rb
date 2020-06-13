require 'test_helper'

class Srf::Api::Songlog::SongTest < ActiveSupport::TestCase
  test '.new' do
    create_srf_api_songlog_song.tap do |srf_api_songlog_song|
      assert_equal 'STRAWBERRY MOON', srf_api_songlog_song.title
      assert_equal 'SONG-ID', srf_api_songlog_song.id

      assert_equal 'Thurston Moore', srf_api_songlog_song.artist.name
    end
  end

  test '#to_song' do
    create_srf_api_songlog_song.to_song.tap do |song|
      assert_equal Song, song.class
      assert_equal 'STRAWBERRY MOON', song.title
      assert song.new_record?
    end
  end

  test '#artist' do
    create_srf_api_songlog_song.artist.tap do |artist|
      assert_equal Artist, artist.class
      assert_equal 'Thurston Moore', artist.name
      assert artist.new_record?
    end
  end

  private

  def create_srf_api_songlog_song
    Srf::Api::Songlog::Song.new(
      srf_api_response('srf/api_response_broadcast.json')['Song']
    )
  end
end
