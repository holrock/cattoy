class Toy < ApplicationRecord
  has_many :histories, dependent: :destroy, inverse_of: :toy

  before_save :trim_amazon_url


  private

  def trim_amazon_url
    if url =~ %r|https?://www.amazon.co.jp/|
      url =~ %r|(/dp/[^/]+/)|
      unless $1
        url =~ %r|(/gp/product/[^/]+/)|
      end
      self.url = "https://www.amazon.co.jp/#{$1}" if $1.present?
    end

  end
end
