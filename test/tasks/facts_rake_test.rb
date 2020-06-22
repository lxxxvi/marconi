require 'test_helper'
require 'rake'

class FactsRakeTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
  end

  test 'it does not raise' do
    assert Rake::Task['facts:all'].invoke
  end
end
