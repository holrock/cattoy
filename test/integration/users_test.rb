require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpder

  test 'get /users' do
    user = users(:one)
    get "/users/#{user.id}"
    assert_response :success
  end

  test 'get /users/new' do
    get "/users/new"
    assert_response :success
  end

  test 'post /users' do
    post "/users", params:
      {user:
       {email: 'test@example.com',
        name: 'test-user',
        password: '12345678',
        password_confirmation: '12345678'}}
    assert_redirected_to '/login'
  end

  test 'get /users/edit' do
    user = users(:one)
    get "/users/#{user.id}/edit"
    assert_redirected_to '/login'
  end

  test 'patch /users/edit' do
    user = users(:one)
    login_user(user)
    get "/users/#{user.id}/edit"
    assert_response :success
    patch "/users/#{user.id}", params:
      {user:
       {email: 'test@example.com',
        name: 'test-user',
        password: '12345678',
        password_confirmation: '12345678'}}

    assert_redirected_to "/users/#{user.id}"
    user.reload
    assert_equal "test-user", user.name
  end
end
