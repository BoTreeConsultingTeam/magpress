require 'faraday'
require 'faraday_middleware'
require 'logger'
# require 'faraday/detailed_logger'
require 'hashie'

# require 'activesupport/middleware'

module Magpress
  class Client
    attr_accessor :url, :options

    def initialize(url, options = {})
      @url = url
      @options = options #.merge(request: { params_encoder: Faraday::FlatParamsEncoder })
    end

    def connection
      conn = ::Faraday.new(url, options) do |faraday|
        faraday.request :json
        # faraday.response :logger, ::Logger.new(STDOUT), bodies: true # :detailed_logger
        faraday.response :mashify
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
      end

      # conn.token_auth access_token unless access_token.nil?
      # conn.params['access_token'] = access_token unless access_token.nil?
      conn.headers['User-Agent'] = 'magnificent.com ruby client'

      conn
    end
  end
end