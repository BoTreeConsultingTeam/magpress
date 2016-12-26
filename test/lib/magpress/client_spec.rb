require './test/minitest_helper'

describe Magpress::Client do
  it 'exists' do
    assert Magpress::Client
  end

  describe '#connection' do
    it 'should give active connection' do
      client = Magpress::Client.new('https://medium.com')

      connection = client.connection
      refute_nil connection

      assert_equal 'https://medium.com/', connection.url_prefix.to_s
      assert_equal 'magnificent.com ruby client', connection.headers['User-Agent']
    end
  end
end
