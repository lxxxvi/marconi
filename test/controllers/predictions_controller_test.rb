require 'test_helper'

class PredictionsControllerTest < ActionDispatch::IntegrationTest
  test '#index with date: today' do
    song1 = songs(:beatles_yesterday)
    song2 = songs(:beatles_help)
    reference_date = Date.new(2020, 11, 11)

    create_prediction!(reference_date, song1, 0.88, 'PLAYED')
    create_prediction!(reference_date, song2, 0.87, 'NOT PLAYED')

    travel_to reference_date do
      get predictions_path(date: 'today')
      assert_response :success

      JSON.parse(response.body).tap do |body|
        assert_equal '2020-11-11', body['date']
        assert_equal 2, body['predictions'].count

        assert_equal 'Yesterday', body['predictions'][0]['song']
        assert_equal 'The Beatles', body['predictions'][0]['artist']
        assert_equal '0.88', body['predictions'][0]['score']
        assert_equal 'PLAYED', body['predictions'][0]['result']

        assert_equal 'Help!', body['predictions'][1]['song']
        assert_equal 'The Beatles', body['predictions'][1]['artist']
        assert_equal '0.87', body['predictions'][1]['score']
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

  private

  def create_prediction!(reference_date, song, score, result)
    Prediction.create!(
      reference_date: reference_date,
      song: song,
      score: score,
      result: result
    )
  end
end
