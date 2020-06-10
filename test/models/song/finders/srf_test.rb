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
    create_srf_api_songlog_song('YESTERDAY', 'Yesterday')
  end

  def srf_api_songlog_song_without_existing_external_key
    create_srf_api_songlog_song('HELP!', 'Help!', 'The Beatles', 'BEATLES')
  end

  def srf_api_songlog_song_new_song
    create_srf_api_songlog_song('OH!-DARLING', 'Oh! Darling', 'The Beatles', 'BEATLES')
  end

  def create_srf_api_songlog_song(id, title, artist_name = "Not relevant", artist_id = "NOT-RELEVANT")
    Srf::Api::Songlog::Song.new({
      "id" => id,
      "title" => title,
      "Artist" => {
        "name" => artist_name,
        "id" => artist_id
      }
    })
  end
end
