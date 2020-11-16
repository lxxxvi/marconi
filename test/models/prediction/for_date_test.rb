require 'test_helper'

class Prediction::ForDateTest < ActiveSupport::TestCase
  test '#as_json for date having results' do
    Prediction::ForDate.new('2020-11-11').as_json.tap do |json|
      assert_equal '2020-11-11', json[:date]
      assert_equal 2, json[:total]
      assert_equal 1, json[:played]
      assert_equal 1, json[:not_played]
      assert_equal 50.0, json[:played_percentage]
      assert_equal 2, json[:predictions].count

      assert_equal 'The Beatles', json[:predictions][0][:artist]
      assert_equal 'Yesterday', json[:predictions][0][:song]
      assert_equal 0.88, json[:predictions][0][:score]
      assert_equal 'PLAYED', json[:predictions][0][:result]

      assert_equal 'The Beatles', json[:predictions][1][:artist]
      assert_equal 'Help!', json[:predictions][1][:song]
      assert_equal 0.87, json[:predictions][1][:score]
      assert_equal 'NOT PLAYED', json[:predictions][1][:result]
    end
  end

  test '#as_json for date not having results' do
    Prediction.update_all(result: nil) # rubocop:disable Rails/SkipsModelValidations

    Prediction::ForDate.new('2020-11-11').as_json.tap do |json|
      assert_equal '2020-11-11', json[:date]
      assert_equal 2, json[:total]
      assert_nil json[:played]
      assert_nil json[:not_played]
      assert_nil json[:played_percentage]
      assert_equal 2, json[:predictions].count
    end
  end

  test '#as_json for date not having predictions' do
    Prediction::ForDate.new('2019-09-19').as_json.tap do |json|
      assert_equal '2019-09-19', json[:date]
      assert_equal 0, json[:total]
      assert_nil json[:played]
      assert_nil json[:not_played]
      assert_nil json[:played_percentage]
      assert_equal 0, json[:predictions].count
    end
  end
end
