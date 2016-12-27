require './test/minitest_helper'

describe Magpress::Login do
  it 'exists' do
    assert Magpress::Login
  end

  describe '#call' do
    it 'should return valid JWT token' do
      login =
          Magpress::Login.new(CREDENTIALS)
      response = login.call

      assert_equal 200, response.status

      body = response.body
      assert_kind_of Hash, body, 'JSON should parsed to Hash'
      assert_equal 1, body.length, 'Body should have exactly one key value pair'
      assert body.auth_key?, 'should have auth_key key present in response'
      assert body.auth_key.length > 0
    end

    context 'with wrong credentials' do
      it 'should return authentication error when username does not match' do
        creds = CREDENTIALS.clone
        creds[:username] = 'amit from botree'
        login =
            Magpress::Login.new(creds)
        response = login.call

        assert_equal 403, response.status
        assert_match /Invalid username/, response.body.message
      end

      it 'should return authentication error when password does not match' do
        creds = CREDENTIALS.clone
        creds[:password] = '**'
        login =
            Magpress::Login.new(creds)
        response = login.call

        assert_equal 403, response.status
        assert_match /password.*incorrect/, response.body.message
      end
    end
  end
end
