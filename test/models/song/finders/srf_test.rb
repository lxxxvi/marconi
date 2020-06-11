require 'test_helper'

class Song::Finders::SrfTest < ActiveSupport::TestCase
  test '#find_or_initialize_by for existing song, with existing external key' do
    Song::Finders::Srf.find_or_initialize_by(srf_api_songlog_song_with_existing_external_key).tap do |song|
      assert_equal songs(:beatles_yesterday), song
    end
  end

  test '#find_or_initialize_by for existing song, without existing external key' do
    Song::Finders::Srf.find_or_initialize_by(srf_api_songlog_song_without_existing_external_key).tap do |song|
      assert_equal songs(:beatles_help), song
      assert song.external_keys.size.positive?
      assert_equal 'HELP!', song.external_keys.first.identifier
    end
  end

  test '#find_or_initialize_by for new song' do
    Song::Finders::Srf.find_or_initialize_by(srf_api_songlog_song_new_song).tap do |song|
      assert song.new_record?
      assert 'Oh! Darling', song.title
      assert song.external_keys.size.positive?
      assert_equal 'OH!-DARLING', song.external_keys.first.identifier
    end
  end

  private

  def srf_api_songlog_song_with_existing_external_key
    new_srf_api_songlog_song('YESTERDAY', 'Yesterday', 'BEATLES')
  end

  def srf_api_songlog_song_without_existing_external_key
    new_srf_api_songlog_song('HELP!', 'Help!', 'BEATLES')
  end

  def srf_api_songlog_song_new_song
    new_srf_api_songlog_song('OH!-DARLING', 'Oh! Darling', 'BEATLES')
  end

  def new_srf_api_songlog_song(song_id, song_title, artist_id)
    song_fixture = srf_api_response('srf/api_response_broadcast.json')['Song']
    song_fixture['id'] = song_id
    song_fixture['title'] = song_title
    song_fixture['Artist']['id'] = artist_id

    Srf::Api::Songlog::Song.new(song_fixture)
  end
end
