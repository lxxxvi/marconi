require 'test_helper'

class FactTest < ActiveSupport::TestCase
  test '#valid?' do
    fact = Fact.new

    assert_changes -> { fact.valid? }, to: true do
      fact.station = stations(:srf3)
      fact.factable = songs(:beatles_help)
      fact.key = 'total_broadcasts'
      fact.value = '100'
    end
  end
end
