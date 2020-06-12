require 'test_helper'

class StationTest < ActiveSupport::TestCase
  test '#save' do
    station = Station.new

    assert_changes -> { station.save }, to: true do
      station.name = 'Stations name'
    end
  end
end
