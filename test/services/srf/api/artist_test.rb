require 'test_helper'

class Srf::Api::ArtistTest < ActiveSupport::TestCase
  test '.new' do
    Srf::Api::Artist.new(example_srf_api_artist_hash).tap do |srf_api_artist|
      assert_equal 'Thurston Moore', srf_api_artist.name
      assert_equal 'ARTIST-ID', srf_api_artist.id
    end
  end

  test '#to_artist' do
    Srf::Api::Artist.new(example_srf_api_artist_hash).to_artist.tap do |artist|
      assert_equal Artist, artist.class
      assert_equal 'Thurston Moore', artist.name
      assert artist.new_record?
    end
  end

  private

  def example_srf_api_artist_hash
    {
      "name" => "Thurston Moore",
      "id" => "ARTIST-ID",
      "modifiedDate" => "2013-02-14T15:50:26+01:00",
      "createdDate" => "2011-03-24T22:48:14+01:00"
    }
  end
end
