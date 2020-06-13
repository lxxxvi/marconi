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
      assert_equal 'YESTERDAY-20200606-BROADCAST', broadcast.external_key
      assert_equal stations(:srf3), broadcast.station
    end
  end

  private

  def srf_api_songlog_broadcast_with_existing_external_key
    new_srf_api_songlog_broadcast(
      'YESTERDAY-20200605-BROADCAST',
      '2020-06-05T16:00:00+00:00',
      'YESTERDAY',
      'BEATLES'
    )
  end

  def srf_api_songlog_broadcast_new_broadcast
    new_srf_api_songlog_broadcast(
      'YESTERDAY-20200606-BROADCAST',
      '2020-06-06T08:00:00+00:00',
      'YESTERDAY',
      'BEATLES'
    )
  end

  def new_srf_api_songlog_broadcast(broadcast_id, broadcasted_at, song_id, artist_id)
    broadcast_fixture = srf_api_response('srf/api_response_broadcast.json')
    broadcast_fixture['id'] = broadcast_id
    broadcast_fixture['playedDate'] = broadcasted_at
    broadcast_fixture['Song']['id'] = song_id
    broadcast_fixture['Song']['Artist']['id'] = artist_id

    Srf::Api::Songlog::Broadcast.new(broadcast_fixture)
  end
end
