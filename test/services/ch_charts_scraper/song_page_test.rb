require 'test_helper'

class ChChartsScraper::SongPageTest < ActiveSupport::TestCase
  test '#scrape with charts' do
    stub_hitparade_ch(
      'https://hitparade.ch/song/Hecht/Besch-ready-fuer-die-Liebi-vo-mer-1901747',
      'hitparade_ch/hecht_besch_ready.html'
    )

    page = ChChartsScraper::SongPage.new('https://hitparade.ch/song/Hecht/Besch-ready-fuer-die-Liebi-vo-mer-1901747')

    assert_equal 'Hecht - Besch ready für die Liebi vo mer?', page.artist_with_song
    assert_equal 2019, page.song_year
    assert_equal Date.new(2020, 2, 23), page.latest_chart_appearance_on
    assert_equal 9, page.chart_peak_position
    assert_equal 25, page.weeks_in_charts
  end

  test '#scrape without charts' do
    stub_hitparade_ch(
      'https://hitparade.ch/song/Bastian-Baker/Another-Day-1806854',
      'hitparade_ch/bastian_baker_another_day.html'
    )

    page = ChChartsScraper::SongPage.new('https://hitparade.ch/song/Bastian-Baker/Another-Day-1806854')

    assert_equal 'Bastian Baker - Another Day', page.artist_with_song
    assert_equal 2018, page.song_year
    assert_nil page.latest_chart_appearance_on
    assert_nil page.chart_peak_position
    assert_nil page.weeks_in_charts
  end

  private

  def stub_hitparade_ch(url, fixture_name)
    stub_request(:get, url).with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Ruby'
      }
    ).to_return(status: 200, body: file_fixture(fixture_name).read, headers: {})
  end
end
