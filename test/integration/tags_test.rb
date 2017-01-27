require 'test_helper'

class TagsTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpder
  test 'get /tags' do
    get '/tags'
    assert_response :success
  end
end
