require 'test_helper'

class FactDecoratorTest < ActiveSupport::TestCase
  test '#value for first_broadcasted_at' do
    facts(:beatles_yesterday_first_broadcasted_at_fact_srf3).decorate.tap do |decorated|
      assert_equal Time.utc(2020, 6, 5, 16, 0, 0), decorated.value
    end
  end

  test '#value for latest_broadcasted_at' do
    facts(:beatles_yesterday_latest_broadcasted_at_fact_srf3).decorate.tap do |decorated|
      assert_equal Time.utc(2020, 6, 5, 16, 0, 0), decorated.value
    end
  end

  test '#value for total_broadcasts' do
    facts(:beatles_yesterday_total_broadcasts_fact_srf3).decorate.tap do |decorated|
      assert_equal 1, decorated.value
    end
  end
end
