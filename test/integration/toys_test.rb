require 'test_helper'

class ToysTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpder

  test 'get /toys' do
    get '/toys'
    assert_response :success
  end

  test 'get /toys/id' do
    toy = toys(:one)
    get '/toys', params: {id: toy}
    assert_response :success
  end

  test 'get /toys/new' do
    get '/toys/new'
    assert_redirected_to '/login'
  end

  test 'get /toys/edit' do
    toy = toys(:one)
    get "/toys/#{toy.id}/edit"
    assert_redirected_to '/login'
  end

  test 'put /toys/id' do
    toy = toys(:one)
    put "/toys/#{toy.id}"
    assert_redirected_to '/login'
  end

  test 'delete /toyy/' do
    toy = toys(:one)
    delete "/toys/#{toy.id}"
    assert_redirected_to '/login'
  end

  test 'create new toy' do
    login_user(users(:one))

    get '/toys/new'
    assert_response :success
    post '/toys',
      params: {toy: {name: 't1', description: 'd', url: 'u', image_url: 'i', tag_list: 'tag1,tag2'}}

    toy = Toy.find_by(name: 't1')
    assert_redirected_to "/toys/#{toy.id}"
  end

  test 'edit toy' do
    login_user(users(:one))

    toy = toys(:one)
    get "/toys/#{toy.id}"
    assert_response :success
    patch "/toys/#{toy.id}",
      params: {toy: {name: 't1', description: 'd', url: 'u', image_url: 'i', tag_list: 'tag1,tag2'}}

    toy.reload
    assert_equal "t1", toy.name
    assert_redirected_to "/toys/#{toy.id}"
  end
end
