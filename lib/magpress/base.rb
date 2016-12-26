require 'magpress/login'

module Magpress
  class Base
    attr_reader :namespace, :username, :password, :options
    attr_accessor :base_url

    REQUEST_FORMAT = '.json'
    def initialize(base_url: , namespace: '', username:, password:, options: {})
      @base_url = base_url
      @username = username
      @password = password
      @namespace = namespace
      @options = options
    end

    def resource_path(resource_id = nil)
      "#{namespace}#{end_point(resource_id)}".freeze
    end

    def auth_key
      Magpress::Login.new(
        base_url: base_url,
        namespace: namespace,
        username: username,
        password: password,
        options: options
      ).call.body['auth_key']
    end

    private
      def connection
        options.merge!(headers: {'Authorization' => auth_key}) if self.class != Login
        @connection ||= Magpress::Client.new(base_url, options).connection
      end

      def end_point(resource_id)
        "#{self.class::END_POINT}#{request_format(resource_id)}"
      end

      def request_format(resource_id)
        resource_id ? "/#{resource_id}#{REQUEST_FORMAT}" : REQUEST_FORMAT
      end
  end
end