class Toy < ApplicationRecord
  has_many :histories, dependent: :destroy, inverse_of: :toy

  validates :name, presence: true

  before_save :trim_amazon_url

  acts_as_taggable

  paginates_per 40

  def to_uri
    RDF::URI.new("#{Const::RDF_HOST}/toys/#{id}")
  end

  private

  def trim_amazon_url
    if url =~ %r|https?://www.amazon.co.jp/|
      url =~ %r|(/dp/[^/]+)|
      unless $1
        url =~ %r|(/gp/product/[^/]+/)|
      end
      self.url = "https://www.amazon.co.jp#{$1}" if $1.present?
    end
  end
end
