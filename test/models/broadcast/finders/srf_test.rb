require 'test_helper'

class Broadcast::Finders::SrfTest < ActiveSupport::TestCase
  test '#find_or_initialize_by for existing broadcast, with existing external_key' do
    Broadcast::Finders::Srf.find_or_initialize_by(srf_api_songlog_broadcast_with_existing_external_key)
                           .tap do |broadcast|
      assert_equal broadcasts(:yesterday_20200605_broadcast), broadcast
    end
  end

  test '#find_or_initialize_by new broadcast' do
    Broadcast::Finders::Srf.find_or_initialize_by(srf_api_songlog_broadcast_new_broadcast).tap do |broadcast|
      assert broadcast.new_record?
      assert_equal songs(:beatles_yesterday), broadcast.song
      assert broadcast.external_keys.size.positive?
      assert_equal 'YESTERDAY-20200606-BROADCAST', broadcast.external_keys.first.identifier
    end
  end

  private

  def srf_api_songlog_broadcast_with_existing_external_key
    Srf::Api::Songlog::Broadcast.new(
      {
        "id" => "YESTERDAY-20200605-BROADCAST",
        "playedDate" => "2020-06-05T16:00:00+00:00",
        "Song" => {
          "id" => "YESTERDAY",
          "Artist" => {
            "name" => "The Beatles",
            "id" => "BEATLES"
          }
        }
      }
    )
  end

  def srf_api_songlog_broadcast_new_broadcast
    Srf::Api::Songlog::Broadcast.new(
      {
        "id" => "YESTERDAY-20200606-BROADCAST",
        "playedDate" => "2020-06-06T08:00:00+00:00",
        "Song" => {
          "id" => "YESTERDAY",
          "Artist" => {
            "id" => "BEATLES"
          }
        }
      }
    )
  end

end
