require 'test_helper'

class SanitizedUrlTest < ActiveSupport::TestCase
  test '.encode' do
    url = "https://hitparade.ch/song/Marie-[Davidson]-&-L'\u008Cil-Nu?abc=def"

    assert_equal 'https://hitparade.ch/song/Marie-%5BDavidson%5D-%26-L%27%C2%8Cil-Nuabc=def',
                 SanitizedUrl.encode(url)
  end
end
