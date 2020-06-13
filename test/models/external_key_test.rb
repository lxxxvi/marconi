require 'test_helper'

class ExternalKeyTest < ActiveSupport::TestCase
  test '#save Artist' do
    external_key = ExternalKey.new

    assert_changes -> { external_key.save }, to: true do
      external_key.identifier = 'POINTER-SISTERS'
      external_key.externally_identifyable = artists(:pointer_sisters)
      external_key.station = stations(:srf3)
    end
  end

  test '#save Song' do
    external_key = ExternalKey.new

    assert_changes -> { external_key.save }, to: true do
      external_key.identifier = 'BEATLES-HELP!'
      external_key.externally_identifyable = songs(:beatles_help)
      external_key.station = stations(:srf3)
    end
  end

  test '.artists' do
    assert_difference -> { ExternalKey.artists.count }, -1 do
      external_keys(:beatles_artist_srf3).destroy
    end
  end

  test '.songs' do
    assert_difference -> { ExternalKey.songs.count }, -1 do
      external_keys(:yesterday_song_srf3).destroy
    end
  end
end
