require 'open-uri'

class Google::SearchResultScraper
  SEARCH_URL = 'https://www.google.ch/search'.freeze

  def initialize(search_term)
    @search_term = search_term
  end

  def search_result_links
    search_result_items.map do |item|
      exctract_href(item['href'])
    end
  end

  def query_url
    "#{SEARCH_URL}?#{to_query_params(params)}"
  end

  private

  def exctract_href(google_href)
    Rack::Utils.parse_query(google_href.sub(%r{^/url\?}, ''))['q']
  end

  def search_result
    @search_result ||= Nokogiri::HTML(perform_search)
  end

  def search_result_items
    @search_result_items ||= search_result.css('a[href^="/url?"]')
  end

  def perform_search
    URI.parse(query_url).open.read
  rescue OpenURI::HTTPError => e
    Rails.logger.error("Called URL: #{query_url}")
    raise e
  end

  def to_google_q(value)
    value.split.map { CGI.escape(_1) }.join('+')
  end

  def to_query_params(hash)
    hash.map { |key, value| "#{key}=#{value}" }.join('&')
  end

  def params
    {
      hl: 'de-CH',
      source: 'hp',
      biw: '',
      bih: '',
      q: to_google_q(@search_term),
      btnG: 'Google+Suche',
      gbv: '1'
    }
  end
end
