require 'test_helper'
require 'rake'

class HerokuRakeTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
  end

  test 'it does not raise' do
    stub_with_fixture(
      url: %r{^https://www.srf.ch/songlog/.*$},
      fixture: 'srf/api_response_songlog_20200605.json'
    )

    assert Rake::Task['heroku:daily'].invoke
  end
end
