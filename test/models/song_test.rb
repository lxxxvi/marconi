require 'test_helper'

class SongTest < ActiveSupport::TestCase
  test '#save' do
    song = Song.new

    assert_changes -> { song.save }, to: true do
      song.title = 'Song title'
      song.artist = artists(:beatles)
    end
  end
end
