require 'test_helper'

class PredictionsControllerTest < ActionDispatch::IntegrationTest
  test '#index with date: today' do
    reference_date = Date.new(2020, 11, 11)

    travel_to reference_date do
      get predictions_path(date: 'today')
      assert_response :success

      JSON.parse(response.body).tap do |body|
        assert_equal '2020-11-11', body['date']
        assert_equal 2, body['predictions'].count

        assert_equal 'Yesterday', body['predictions'][0]['song']
        assert_equal 'PLAYED', body['predictions'][0]['result']

        assert_equal 'Help!', body['predictions'][1]['song']
        assert_equal 'NOT PLAYED', body['predictions'][1]['result']
      end
    end
  end

  test '#index with custom date' do
    get predictions_path(date: '2020-02-02')
    assert_response :success

    JSON.parse(response.body).tap do |body|
      assert_equal '2020-02-02', body['date']
      assert_equal 0, body['predictions'].count
    end
  end
end
