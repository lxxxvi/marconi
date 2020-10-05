require 'test_helper'

class IlikeTest < ActiveSupport::TestCase
  test '.ilike' do
    assert_equal "SELECT \"artists\".* FROM \"artists\" WHERE (name ILIKE 'Foo%' OR name ILIKE '%Bar')",
                 Artist.ilike(name: ['Foo%', '%Bar']).to_sql
  end
end
