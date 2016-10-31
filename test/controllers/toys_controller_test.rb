require 'test_helper'

class ToysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @toy = toys(:one)
  end

  test "should get index" do
    get toys_url
    assert_response :success
  end

  test "should get new" do
    get new_toy_url
    assert_redirected_to login_url
  end

  test "should create toy" do
    assert_no_difference('Toy.count') do
      post toys_url, params: { toy: { description: @toy.description, image_url: @toy.image_url, name: @toy.name, url: @toy.url } }
    end
    assert_redirected_to login_url
  end

  test "should show toy" do
    get toy_url(@toy)
    assert_response :success
  end

  test "should get edit" do
    get edit_toy_url(@toy)
    assert_redirected_to login_url
  end

  test "should update toy" do
    patch toy_url(@toy), params: { toy: { description: @toy.description, image_url: @toy.image_url, name: @toy.name, url: @toy.url } }
    assert_redirected_to login_url
  end

  test "should destroy toy" do
    assert_difference('Toy.count', 0) do
      delete toy_url(@toy)
    end

    assert_redirected_to login_url
  end
end
