require 'open-uri'

class ChChartsScraper::Song::Page
  def initialize(url)
    @url = url
  end

  def artist_with_song
    read_artist_with_song
  end

  def song_year
    @song_year ||= read_year
  end

  def chart_facts
    @chart_facts ||= {
      latest_chart_appearance_on: read_latest_chart_appearance_on,
      chart_peak_position: read_chart_peak_position,
      weeks_in_charts: read_weeks_in_charts
    }
  end

  private

  def read_artist_with_song
    nhtml.css('h1').first.text
  end

  def read_year
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
    URI.open(sanitized_url).read
  end

  def sanitized_url
    @url.gsub('[', '%5B').gsub(']', '%5D')
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
    return if cell_key_element.nil?

    cell_key_element.next_sibling.text
  end

  def find_element_by_text(node, selector, text)
    node.css(selector)&.find { _1.text == text }
  end
end
