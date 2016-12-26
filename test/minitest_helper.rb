$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'magpress'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest-spec-context'
require './lib/magpress'
require 'magpress/login'
require 'mocha/mini_test'
# require 'webmock/minitest'
# require 'vcr'
require 'pry'

# VCR.configure do |c|
#   c.cassette_library_dir = "test/fixtures"
#   c.hook_into :webmock
# end

CREDENTIALS =  {
    base_url: ENV['CMS_BASE_URL'],
    namespace: ENV['CMS_NAMESPACE'],
    username: ENV['CMS_USERNAME'],
    password: ENV['CMS_PASSWORD']
}
INTEGER_REGEX = /^[-+]?[0-9]+$/
LOGIN = Magpress::Login.new(CREDENTIALS)
def auth_key
  LOGIN.call.body['auth_key']
end