require 'test_helper'

class ChChartsScraper::SongTest < ActiveSupport::TestCase
  test '#call' do
    stub_the_roots_the_seed_hitparade_ch_song_search
    stub_the_roots_the_seed_hitparade_ch

    song = songs(:the_roots_the_seed)

    service = ChChartsScraper::Song.new(song)

    assert_difference -> { song.charts_facts.count }, 3 do
      service.call!
    end

    assert_equal '2002', song.year
    assert_equal Date.new(2003, 8, 24), song.charts_fact('CH', 'latest_chart_appearance_on').decorated_value
    assert_equal 22, song.charts_fact('CH', 'chart_peak_position').decorated_value
    assert_equal 16, song.charts_fact('CH', 'weeks_in_charts').decorated_value
  end

  test '#call but incorrect url' do
    stub_the_roots_the_seed_hitparade_ch_song_search
    stub_the_roots_the_seed_hitparade_ch_incorrect_response

    song = songs(:the_roots_the_seed)

    service = ChChartsScraper::Song.new(song)

    assert_changes -> { song.reload.ch_charts_scraper_status }, to: 'incorrect_url' do
      service.call!
    end
  end

  private

  def stub_the_roots_the_seed_hitparade_ch_song_search
    stub_with_fixture(
      url: 'https://hitparade.ch/search.asp?artist=The%20Roots&artist_search=starts&cat=s&from=&title=The%20Seed%20(2.0)&title_search=starts&to=',
      fixture: 'hitparade_ch/search_the_roots_the_seed.html'
    )
  end

  def stub_the_roots_the_seed_hitparade_ch
    stub_with_fixture(
      url: 'https://hitparade.ch/song/The-Roots-feat.-Cody-ChesnuTT/The-Seed-(2.0)-5597',
      fixture: 'hitparade_ch/song_the_roots_the_seed.html'
    )
  end

  def stub_the_roots_the_seed_hitparade_ch_incorrect_response
    stub_with_fixture(
      url: 'https://hitparade.ch/song/The-Roots-feat.-Cody-ChesnuTT/The-Seed-(2.0)-5597',
      fixture: 'hitparade_ch/song_beatles_yesterday.html'
    )
  end
end
