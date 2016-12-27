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

def assert_unauthorized_token(klass, method, *params)
  Magpress::Base.any_instance.stubs(:auth_key).returns('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcHBzLm9wZW50ZXN0ZHJpdmUuY29tOjgwODBcL21hZ25pZmljZW50IiwiaWF0IjoxNDgyMzI0Mzg1LCJuYmYiOjE0ODIzMjQzODUsImV4cCI6MTQ4MjM0MTY2NSwiZGF0YSI6eyJ1c2VyIjp7ImlkIjoiMSJ9fX0.JhRq2AyurGHNPYQAGH-W2XvdizB2f6ktfiO1qWxrgA1') #mocha

  post = klass.new(CREDENTIALS)
  response = params ? post.send(method, *params) :  post.send(method)

  assert_equal 403, response.status
  #TODO verify error body
end

def assert_resource_attributes(resource, response, expected_attributes)
  attributes_list = response.body.kind_of?(Array)? response.body.first.keys : response.body.keys
  assert_equal expected_attributes, attributes_list, "Any return #{resource} should have all required attributes"
end