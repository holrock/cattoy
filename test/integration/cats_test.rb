require 'test_helper'

class CatsTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpder

  test 'get /cats/id' do
    cat = cats(:one)
    get "/cats/#{cat.id}"
    assert_response :success
  end

  test 'get /cats/new' do
    get "/cats/new"
    assert_redirected_to '/login'
  end

  test 'get /cats/edit' do
    cat = cats(:one)
    get "/cats/#{cat.id}/edit"
    assert_redirected_to '/login'
  end

  test 'post /cats' do
    post "/cats"
    assert_redirected_to '/login'
  end

  test 'patch /cats/' do
    cat = cats(:one)
    patch "/cats/#{cat.id}"
    assert_redirected_to '/login'
  end

  test 'delete /cats/' do
    cat = cats(:one)
    delete "/cats/#{cat.id}"
    assert_redirected_to '/login'
  end

  test 'create new cat' do
    user = users(:one)
    login_user(user)
    get "/cats/new"
    assert_response :success

    assert_difference "Cat.count", 1 do
      post "/cats", params: {
        cat: {
          name: 'cattest',
          user_id: user.id,
          image_url: 'image_url'
        }
      }
    end
    cat = Cat.find_by(name: 'cattest')
    assert_equal user.id, cat.user_id
    assert_redirected_to "/users/#{user.id}"
  end

  test 'edit my cat' do
    user = users(:one)
    login_user(user)

    cat = user.cats.first
    get "/cats/#{cat.id}/edit"
    assert_response :success
    patch "/cats/#{cat.id}", params: {cat: {name: 'newcatname'}}
    cat.reload
    assert_equal 'newcatname', cat.name
    assert_redirected_to "/cats/#{cat.id}"
  end

  test 'edit other cat' do
    user = users(:one)
    login_user(user)

    cat = users(:two).cats.first
    assert_raises(ActiveRecord::RecordNotFound) do
      get "/cats/#{cat.id}/edit"
    end
    assert_raises(ActiveRecord::RecordNotFound) do
      patch "/cats/#{cat.id}", params: {cat: {name: 'newcatname'}}
    end
  end

  test 'remove my cat' do
    user = users(:one)
    login_user(user)

    cat = user.cats.first
    assert_difference "Cat.count", -1 do
      delete "/cats/#{cat.id}"
    end
    assert_redirected_to "/users/#{user.id}"
  end

  test 'remove other cat' do
    user = users(:one)
    login_user(user)

    cat = users(:two).cats.first
    assert_raises(ActiveRecord::RecordNotFound) do
      assert_no_difference "Cat.count" do
        delete "/cats/#{cat.id}"
      end
    end
  end
end
