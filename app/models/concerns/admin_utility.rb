require 'uri'

module AdminUtility
  extend ActiveSupport::Concern

  included do
    def valid_url?(url)
      uri = URI.parse(url)
      (uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS) ) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
    end
  end
end