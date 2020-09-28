require 'open-uri'

class HitparadeCh::SongSearch
  URL = 'https://hitparade.ch'.freeze
  SEARCH_URL = 'https://hitparade.ch/search.asp'.freeze

  def initialize(artist_name, song_title)
    @artist_name = artist_name
    @song_title = song_title
  end

  def search_result_links
    search_result_items.map do |item|
      "#{URL}#{item['href']}"
    end
  end

  def query_url
    "#{SEARCH_URL}?#{to_query_params(params)}"
  end

  private

  def search_result
    @search_result ||= Nokogiri::HTML(perform_search)
  end

  def search_result_items
    @search_result_items ||= search_result.css('td a[href^="/song/"]')
  end

  def perform_search
    URI.open(query_url).read
  rescue OpenURI::HTTPError => e
    Rails.logger.error("Called URL: #{query_url}")
    raise e
  end

  def to_query_param(value)
    value.split(' ').map { CGI.escape(_1) }.join('+')
  end

  def to_query_params(hash)
    hash.map { |key, value| "#{key}=#{value}" }.join('&')
  end

  def params
    {
      cat: 's',
      from: '',
      to: '',
      artist: to_query_param(@artist_name),
      artist_search: 'starts',
      title: to_query_param(@song_title),
      title_search: 'starts'
    }
  end
end