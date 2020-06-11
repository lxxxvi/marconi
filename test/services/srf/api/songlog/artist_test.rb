require 'test_helper'

class Srf::Api::Songlog::ArtistTest < ActiveSupport::TestCase
  test '.new' do
    create_srf_api_songlog_artist.tap do |srf_api_songlog_artist|
      assert_equal 'Thurston Moore', srf_api_songlog_artist.name
      assert_equal 'ARTIST-ID', srf_api_songlog_artist.id
    end
  end

  test '#to_artist' do
    create_srf_api_songlog_artist.to_artist.tap do |artist|
      assert_equal Artist, artist.class
      assert_equal 'Thurston Moore', artist.name
      assert artist.new_record?
    end
  end

  private

  def create_srf_api_songlog_artist
    Srf::Api::Songlog::Artist.new(
      srf_api_response('srf/api_response_broadcast.json')['Song']['Artist']
    )
  end
end
