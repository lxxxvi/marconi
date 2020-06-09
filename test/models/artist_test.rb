require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  test '#save' do
    artist = Artist.new

    assert_changes -> { artist.valid? }, to: true  do
      artist.name = 'Foo Fighters'
    end
  end
end
