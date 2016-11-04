require 'test_helper'

class PagesTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpder

  test 'get /pages/about' do
    get "/pages/about"
    assert_response :success
  end

  test 'get /pages/usage' do
    get "/pages/usage"
    assert_response :success
  end

  test 'get /pages/about with login' do
    user = users(:one)
    login_user(user)
    get "/pages/about"
    assert_response :success
  end

  test 'get /pages/usage with login' do
    user = users(:one)
    login_user(user)
    get "/pages/usage"
    assert_response :success
  end
end
