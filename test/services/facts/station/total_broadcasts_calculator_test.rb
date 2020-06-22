require 'test_helper'

class Facts::Station::TotalBroadcastsTest < ActiveSupport::TestCase
  test '#call!' do
    station = stations(:srf3)
    number = 3

    total_broadcasts_for_station(station)

    assert_difference -> { total_broadcasts_for_station(station) }, number do
      create_more_broadcasts!(station, number)
      Facts::Station::TotalBroadcasts.new.call!
    end
  end

  private

  def total_broadcasts_for_station(station)
    station.facts.find_or_initialize_by(key: :total_broadcasts).decorated_value
  end

  def create_more_broadcasts!(station, number)
    first_broadcast = station.broadcasts.first

    number.times do |index|
      new_broadcast = first_broadcast.dup
      new_broadcast.external_key = "EXTERNAL-KEY-#{index}"
      new_broadcast.broadcasted_at += (index + 1).day
      new_broadcast.save!
    end
  end
end
