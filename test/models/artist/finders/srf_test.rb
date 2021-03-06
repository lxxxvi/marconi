require 'test_helper'

class Artist::Finders::SrfTest < ActiveSupport::TestCase
  test '#find_or_initialize_by for existing artist, with existing external key' do
    Artist::Finders::Srf.find_or_initialize_by(srf_api_songlog_artist_with_existing_external_key) do |artist|
      assert_equal artists(:beatles), artist
    end
  end

  test '#find_or_initialize_by for existing artist, without existing external key' do
    Artist::Finders::Srf.find_or_initialize_by(srf_api_songlog_artist_without_existing_external_key).tap do |artist|
      assert_equal artists(:pointer_sisters), artist
      assert artist.external_keys.size.positive?
      assert_equal 'POINTER-SISTERS', artist.external_keys.first.identifier
    end
  end

  test '#find_or_initialize_by for new artist' do
    Artist::Finders::Srf.find_or_initialize_by(srf_api_songlog_artist_new_artist).tap do |artist|
      assert artist.new_record?
      assert 'Run The Jewels', artist.name
      assert artist.external_keys.size.positive?
      assert_equal 'RUN-THE-JEWELS', artist.external_keys.first.identifier
      assert_equal stations(:srf3), artist.external_keys.first.station
    end
  end

  private

  def srf_api_songlog_artist_with_existing_external_key
    Srf::Api::Songlog::Artist.new({ 'name' => 'The Beatles', 'id' => 'BEATLES' })
  end

  def srf_api_songlog_artist_without_existing_external_key
    Srf::Api::Songlog::Artist.new({ 'name' => 'Pointer Sisters', 'id' => 'POINTER-SISTERS' })
  end

  def srf_api_songlog_artist_new_artist
    Srf::Api::Songlog::Artist.new({ 'name' => 'Run The Jewels', 'id' => 'RUN-THE-JEWELS' })
  end

  def new_srf_api_songlog_artist(artist_id, artist_name)
    artist_fixture = srf_api_response('srf/api_response_broadcast.json')['Song']['Artist']
    artist_fixture['id'] = artist_id
    artist_fixture['name'] = artist_name

    Srf::Api::Songlog::Artist.new(artist_fixture)
  end
end
