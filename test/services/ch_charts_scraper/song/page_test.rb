require 'test_helper'

class ChChartsScraper::Song::PageTest < ActiveSupport::TestCase
  test '#scrape with charts' do
    stub_with_fixture(
      url: 'https://hitparade.ch/song/Hecht/Besch-ready-fuer-die-Liebi-vo-mer-1901747',
      fixture: 'hitparade_ch/song_hecht_besch_ready.html'
    )

    page = ChChartsScraper::Song::Page.new('https://hitparade.ch/song/Hecht/Besch-ready-fuer-die-Liebi-vo-mer-1901747')

    assert_equal 'Hecht - Besch ready für die Liebi vo mer?', page.artist_with_song
    assert_equal 2019, page.song_year
    assert_equal Date.new(2020, 2, 23), page.chart_facts[:latest_chart_appearance_on]
    assert_equal 9, page.chart_facts[:chart_peak_position]
    assert_equal 25, page.chart_facts[:weeks_in_charts]
  end

  test '#scrape without charts' do
    stub_with_fixture(
      url: 'https://hitparade.ch/song/Bastian-Baker/Another-Day-1806854',
      fixture: 'hitparade_ch/song_bastian_baker_another_day.html'
    )

    page = ChChartsScraper::Song::Page.new('https://hitparade.ch/song/Bastian-Baker/Another-Day-1806854')

    assert_equal 'Bastian Baker - Another Day', page.artist_with_song
    assert_equal 2018, page.song_year
    assert_nil page.chart_facts[:latest_chart_appearance_on]
    assert_nil page.chart_facts[:chart_peak_position]
    assert_nil page.chart_facts[:weeks_in_charts]
  end
end
