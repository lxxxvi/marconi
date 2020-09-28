class SanitizedUrl
  URIREGEX = %r{^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?$}.freeze

  def initialize(uri)
    @uri = uri
  end

  def self.encode(uri)
    new(uri).encode
  end

  def encode
    "#{scheme}://#{authority}#{path}#{query}"
  end

  private

  def scheme
    fragments[:scheme]
  end

  def authority
    fragments[:authority]
  end

  def path
    CGI.escape(fragments[:path]).gsub(/%2F/, '/')
  end

  def query
    fragments[:query]
  end

  def fragments
    @fragments ||= {
      scheme: scanned[1],
      authority: scanned[3],
      path: scanned[4],
      query: scanned[6]
    }
  end

  def scanned
    @scanned ||= @uri.scan(URIREGEX)[0]
  end
end
