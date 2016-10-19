require 'test_helper'

class ToyTest < ActiveSupport::TestCase
  test "trim_amazon_url" do
    url = 'https://www.amazon.co.jp/おもちゃ遊び/dp/B00XXXXXXX/refhogeghoe'
    toy = Toy.new(name:'test', url: url)
    toy.save!
    assert_equal 'https://www.amazon.co.jp/dp/B00XXXXXXX/', toy.url
  end
end
