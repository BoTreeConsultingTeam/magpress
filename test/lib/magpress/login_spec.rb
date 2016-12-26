require './test/minitest_helper'

describe Magpress::Login do
  it 'exists' do
    assert Magpress::Login
  end

  describe '#call' do
    it 'should return valid JWT token' do
      #TODO remove hardcoded creds
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

    it 'should return authentication error for wrong credentials' do
      creds = CREDENTIALS.clone
      creds[:password] = '**'
      login =
          Magpress::Login.new(creds)
      response = login.call

      assert_equal 403, response.status
      # TODO: check response body for detailed message
      # assert_matches /Incorrect username or password/, response.body['message']
    end
  end
end
