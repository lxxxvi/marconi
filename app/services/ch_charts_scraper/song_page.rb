require 'open-uri'

class ChChartsScraper::SongPage
  def initialize(url)
    @url = url
  end

  def artist_with_song
    @artist_with_song ||= read_artist_with_song
  end

  def song_year
    @song_year ||= read_song_year
  end

  def latest_chart_appearance_on
    @latest_chart_appearance_on ||= read_latest_chart_appearance_on
  end

  def chart_peak_position
    @chart_peak_position ||= read_chart_peak_position
  end

  def weeks_in_charts
    @weeks_in_charts ||= read_weeks_in_charts
  end

  private

  def read_artist_with_song
    nhtml.css('h1').first.text
  end

  def read_song_year
    value_from_table(:song, 'Jahr:')&.to_i
  end

  def read_latest_chart_appearance_on
    raw_value = value_from_table(:charts, 'Zuletzt:')
    return if raw_value.nil?

    date_part = raw_value.split(' ').first
    Date.strptime(date_part, '%d.%m.%Y')
  end

  def read_chart_peak_position
    raw_value = value_from_table(:charts, 'Höchstposition:')
    return if raw_value.nil?

    raw_value.match(/^([0-9]+)?/)[0].to_i
  end

  def read_weeks_in_charts
    raw_value = value_from_table(:charts, 'Anzahl Wochen:')
    return if raw_value.nil?

    raw_value.match(/^([0-9]+)?/)[0].to_i
  end

  def nhtml
    @nhtml ||= Nokogiri::HTML(fetch_url)
  end

  def fetch_url
    URI.open(@url).read
  end

  def tables
    @tables ||= {
      song: read_table_underneath_h2('Song'),
      charts: read_table_underneath_h2('Charts')
    }
  end

  def read_table_underneath_h2(h2_text)
    h2_element = find_element_by_text(nhtml, 'h2', h2_text)
    h2_element.parent.css('table').first
  end

  def value_from_table(table_key, cell_key)
    return if tables[table_key].blank?

    cell_key_element = find_element_by_text(tables[table_key], 'tr > td', cell_key)
    cell_key_element.next_sibling.text
  end

  def find_element_by_text(node, selector, text)
    node.css(selector)&.find { _1.text == text }
  end
end
