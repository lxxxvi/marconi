require 'test_helper'

class SongTest < ActiveSupport::TestCase
  test '#save' do
    song = Song.new

    assert_changes -> { song.save }, to: true do
      song.title = 'Song title'
      song.artist = artists(:beatles)
    end
  end

  test '#initialize_ch_charts_scraper_status' do
    assert_equal 'new', Song.new.ch_charts_scraper_status
    assert_not_nil Song.new.ch_charts_scraper_status_updated_at
  end
end
