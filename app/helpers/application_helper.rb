module ApplicationHelper
  IMAGE_HOST = Cattoy::Application.config.image_host

  def self.build_image_proxy_url(url, w:nil, h:nil)
    digest = OpenSSL::HMAC.hexdigest('sha1', Rails.application.secrets.omac_key, url)
    size = nil
    if w && h
      size = "&widt=#{w}&h=#{h}"
    end
    "#{IMAGE_HOST}/#{digest}?url=#{Rack::Utils.escape(url)}#{size}"
  end

  def image_proxy_url(url, w:nil, h:nil)
    ApplicationHelper.build_image_proxy_url(url, w: w, h: h)
  end

  SrcScrubber = Loofah::Scrubber.new do |node|
    if node.name == 'img'
      node['src'] = build_image_proxy_url(node['src'])
    end
  end

  TAGS = %w(a img).freeze
  ATTRS = %w(href src width height).freeze

  def comment_format(history)
    sanitized = sanitize(history.comment, tags: TAGS, attributes: ATTRS)
    sanitized = sanitize(sanitized, scrubber: SrcScrubber)
    simple_format(sanitized)
  end
end
