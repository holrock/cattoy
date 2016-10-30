module ApplicationHelper
  IMAGE_HOST = Cattoy::Application.config.image_host

  def image_proxy_url(url)
    digest = OpenSSL::HMAC.hexdigest('sha1', Rails.application.secrets.omac_key, url)
    "#{IMAGE_HOST}/#{digest}?url=#{Rack::Utils.escape(url)}"
  end
end
