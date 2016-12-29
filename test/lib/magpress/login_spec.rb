require './test/minitest_helper'
require 'hashie'

describe Magpress::Login do
  it 'exists' do
    assert Magpress::Login
  end

  describe '#call' do
    it 'should return valid JWT token' do
      response = Magpress::Login.new(CREDENTIALS).call

      assert_kind_of Hashie::Mash, response, 'JSON should parsed to Hash'
      assert_equal 1, response.length, 'Body should have exactly one key value pair'
      assert response.auth_key?, 'should have auth_key key present in response'
      assert response.auth_key.length > 0
    end

    context 'with wrong credentials' do
      it 'should return authentication error when username does not match' do
        creds = CREDENTIALS.clone
        creds[:username] = 'amit from botree'
        assert_unauthorized(creds, /Invalid username/)
      end

      it 'should return authentication error when password does not match' do
        creds = CREDENTIALS.clone
        creds[:password] = '**'
        assert_unauthorized(creds, /password.*incorrect/)
      end
    end
  end

  def assert_unauthorized(creds, expected_error_regex)
    error = assert_raises Magpress::UnauthorizedError do
      Magpress::Login.new(creds).call
    end
    assert_match expected_error_regex, error.message
  end
end
