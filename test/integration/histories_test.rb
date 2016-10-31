require 'test_helper'

class HistoriesTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpder

  test 'get /histories' do
    get '/histories'
    assert_response :success
  end

  test 'get /histories/show' do
    history = histories(:one)
    get "/histories/#{history.id}"
    assert_response :success
  end

  test 'post /histories' do
    post '/histories'
    assert_redirected_to '/login'
  end

  test 'get /histories/edit' do
    history = histories(:one)
    get "/histories/#{history.id}/edit"
    assert_redirected_to '/login'
  end

  test 'patch /histories' do
    history = histories(:one)
    patch "/histories/#{history.id}"
    assert_redirected_to '/login'
  end

  test 'new history' do
    user = users(:one)
    login_user(user)

    assert_difference 'History.count', 1 do
      post '/histories', params: {
        history: {
          toy_id: toys(:two).id,
          cat_id: user.cats.first.id,
          rate: 1,
          comment: 'hoge'
        }
      }
    end
    history = History.find_by(toy_id: toys(:two).id, cat_id: user.cats.first.id)
    assert_redirected_to "/histories/#{history.id}"
    assert_equal 'hoge', history.comment
  end

  test 'duplicated hew history' do
    user = users(:one)
    login_user(user)

    assert_difference 'History.count', 0 do
      post '/histories', params: {
        history: {
          toy_id: toys(:one).id,
          cat_id: user.cats.first.id,
          rate: 1,
          comment: 'hoge'
        }
      }
    end
    assert_response :success
  end

  test 'new history with other cat' do
    user = users(:one)
    login_user(user)
    cat = cats(:two)

    assert_difference 'History.count', 0 do
      post '/histories', params: {
        history: {
          toy_id: toys(:one).id,
          cat_id: cat.id,
          rate: 1,
          comment: 'hoge'
        }
      }
    end
    assert_response :success
  end

  test 'edit history' do
    user = users(:one)
    login_user(user)
    cat = cats(:one)
    history = cat.histories.first
    get "/histories/#{history.id}/edit"
    assert_response :success
    patch "/histories/#{history.id}", params: {
      history: {
        toy_id: toys(:two).id,
        cat_id: user.cats.first.id,
        rate: -1,
        comment: 'bar'
      }
    }
    assert_redirected_to "/histories/#{history.id}"
    history.reload
    assert_equal(-1, history.rate)
  end

  test 'edit history with other cat' do
    user = users(:one)
    login_user(user)
    cat = cats(:one)
    history = cat.histories.first
    get "/histories/#{history.id}/edit"
    assert_response :success
    patch "/histories/#{history.id}", params: {
      history: {
        toy_id: toys(:two).id,
        cat_id: cats(:two).id,
        rate: -1,
        comment: 'bar'
      }
    }
    assert_response :success
    history.reload
    assert_equal(cat.id, history.cat.id)
  end
end
