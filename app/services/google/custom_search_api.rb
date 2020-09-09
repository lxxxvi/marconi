require 'open-uri'

class Google::CustomSearchApi
  HITPARADE_CH_SEARCH_ENGINE_ID = 'a585049f35d8e28ca'.freeze

  def initialize(search_term)
    @search_term = search_term
  end

  def search_result
    @search_result ||= JSON.parse(perform_search)
  end

  def search_result_items
    search_result['items']
  end

  private

  def perform_search
    URI.open(google_query_url).read
  rescue OpenURI::HTTPError => e
    Rails.logger.error("Called URL: #{google_query_url}")
    raise e
  end

  def to_google_q(value)
    value.split(' ').map { CGI.escape(_1) }.join('+')
  end

  def to_query_params(hash)
    hash.map { |key, value| "#{key}=#{value}" }.join('&')
  end

  def google_query_url
    "https://www.googleapis.com/customsearch/v1?#{to_query_params(params)}"
  end

  def params
    {
      key: Rails.application.credentials[:google_custom_search_api_key],
      cx: HITPARADE_CH_SEARCH_ENGINE_ID,
      siteSearch: 'hitparade.ch/song',
      siteSearchFilter: 'i',
      num: '1',
      q: to_google_q(@search_term)
    }
  end
end
